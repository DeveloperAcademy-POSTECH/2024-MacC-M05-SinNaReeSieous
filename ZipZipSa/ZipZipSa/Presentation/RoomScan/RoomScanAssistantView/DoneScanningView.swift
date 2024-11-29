//
//  DoneScanningView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/26/24.
//

import SwiftUI
import Vision
import CoreImage.CIFilterBuiltins

struct DoneScanningView: View {
    @Environment(\.dismiss) var dismiss
    @State var showErrorAlert: Bool = false
    @Binding var capturedView: UIImage?
    @Binding var model: UIImage?
    @Binding var isProcessing: Bool
    @Binding var showResultSheet: Bool
    @Binding var doneScanning: Bool
    let roomManager: RoomPlanManager
    
    var body: some View {
        VStack {
            DoneScanText
            Spacer()
            HStack(spacing: 8) {
                ReScanButton
                SaveButton
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .alert("경고", isPresented: $showErrorAlert) {
            Button("건너뛰기", role: .destructive) {
                // TODO: 집 모델 = nil인 상태로 결과지 띄우기
            }
            
            Button("다시찍기", role: .cancel) {
                doneScanning = false
                isProcessing = false
                dismiss()
            }
        } message: {
            Text("집 모델이 없습니다.\n모델이 없는 상태로 결과지를 보시려면 건너뛰기를 눌러주세요.")
                .multilineTextAlignment(.center)
        }
    }
}

private extension DoneScanningView {
    // MARK: - View
    
    var DoneScanText: some View {
        Text(ZipLiteral.RoomScan.doneSacnText)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .title2)
            .padding(.top, 17)
    }
    
    var ReScanButton: some View {
        Button {
            doneScanning = false
            roomManager.startSession()
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.Button.secondaryBlue)
                .frame(height: 53)
                .overlay(
                    Text(ZipLiteral.RoomScan.reScasn)
                        .foregroundStyle(Color.Text.secondary)
                        .applyZZSFont(zzsFontSet: .bodyBold)
                )
        }
    }
    
    var SaveButton: some View {
        Button {
            isProcessing = true
            captureScreen()
            if let modelImage = capturedView {
                createSticker(image: modelImage)
            }
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.Button.primaryBlue)
                .frame(height: 53)
                .overlay(
                    Text(isProcessing ? ZipLiteral.RoomScan.processing : ZipLiteral.RoomScan.save)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyBold)
                )
        }
        .disabled(isProcessing)
    }
    
    // MARK: - Action
    
    //캡쳐된 모델이 보이는 뷰를 이미지로 캡쳐하기 위한 함수
    func captureScreen() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                let rootView = window.rootViewController?.view
                let topMargin: CGFloat = 100
                let bottomMargin: CGFloat = 300
                let screenHeight = UIScreen.main.bounds.height
                let screenWidth = UIScreen.main.bounds.width
                let rect = CGRect(x: 0, y: topMargin, width: screenWidth, height: screenHeight - topMargin - bottomMargin)
                capturedView = rootView?.snapshot(of: rect)
            }
        }
    }
    
    //이미지의 배경을 제거하는 함수
    func createSticker(image: UIImage) {
        let processingQueue = DispatchQueue(label: "ProcessingQueue")
        
        guard let inputImage = CIImage(image: image) else {
            print("Failed to create CIImage")
            return
        }
        processingQueue.async {
            guard let maskImage = subjectMaskImage(from: inputImage) else {
                print("Failed to create mask image")
                DispatchQueue.main.async {
                }
                capturedView = nil
                showErrorAlert = true
                return
            }
            let outputImage = apply(mask: maskImage, to: inputImage)
            let image = render(ciImage: outputImage)
            DispatchQueue.main.async {
                self.model = image
            }
        }
    }
    
    // 이미지의 배경을 제거하기 위한 Mask를 만들어주는 함수
    func subjectMaskImage(from inputImage: CIImage) -> CIImage? {
        let handler = VNImageRequestHandler(ciImage: inputImage, options: [:])
        let request = VNGenerateForegroundInstanceMaskRequest()
        
        do {
            try handler.perform([request])
            guard let result = request.results?.first else {
                print("No observations found")
                return nil
            }
            let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
            return CIImage(cvPixelBuffer: maskPixelBuffer)
        } catch {
            print(error)
            return nil
        }
    }
    
    // 이미지에 Mask를 적용하는 함수
    func apply(mask: CIImage, to image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        return filter.outputImage!
    }
    
    // 적용된 Mask에 따라 배경을 제거한 이미지를 리턴하는 함수
    func render(ciImage: CIImage) -> UIImage {
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else {
            fatalError("Failed to render CGImage")
        }
        return UIImage(cgImage: cgImage)
    }
}
