//
//  RoomScanView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import SwiftData
import RoomPlan
import Vision
import CoreLocation
import CoreImage.CIFilterBuiltins

struct RoomScanView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @StateObject private var locationManager = LocationManager()
    
    @State private var room: SampleRoom?
    @State private var doneScanning: Bool = false
    @State private var capturedView: UIImage?
    @State private var model: UIImage?
    @State private var mainPicture: UIImage?
    @State private var showResultSheet: Bool = false
    @State private var isProcessing: Bool = false
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @Binding var hasRoomModel: Bool
    
    let roomController = RoomPlanManager.shared
    
    var body: some View {
        VStack {
            if doneScanning {
                Text(ZipLiteral.RoomScan.doneSacnText)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
            
            ZStack {
                RoomCaptureViewRepresentable()
                    .onAppear {
                        roomController.startSession()
                    }
                    .onDisappear {
                        roomController.stopSession()
                    }
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    if doneScanning == false {
                        // scanningButtonsView
                        HStack {
                            Button {
                                // TODO: 이전 뷰(RoomScanInfoView)로 돌아가기
                                dismiss()
                            } label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.gray)
                                    .frame(width: 165, height: 50)
                                    .overlay(
                                        Text(ZipLiteral.RoomScan.cancle)
                                            .foregroundStyle(Color.white)
                                    )
                            }
                            
                            Spacer()
                                .frame(width: 20)
                            
                            Button {
                                roomController.stopSession()
                                doneScanning = true
                            } label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.primary)
                                    .frame(width: 165, height: 50)
                                    .overlay(
                                        Text(ZipLiteral.RoomScan.done)
                                            .foregroundStyle(Color.white)
                                    )
                            }
                        }
                    } else {
                        // doneScanningButtonsView
                        HStack {
                            Button {
                                doneScanning = false
                                roomController.startSession()
                            } label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color.gray)
                                    .frame(width: 160, height: 50)
                                    .overlay(
                                        Text(ZipLiteral.RoomScan.reScasn)
                                            .foregroundStyle(Color.white)
                                    )
                            }
                            
                            Spacer()
                                .frame(width: 20)
                            
                            Button {
                                isProcessing = true
                                
                                // 3D 모델 화면캡쳐 및 배경제거
                                captureScreen()
                                if let modelImage = capturedView {
                                    createSticker(image: modelImage)
                                }
                                
                                // 저장하기에서 오류가 날 경우 다시 찍도록 처리
                            } label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.primary)
                                    .frame(width: 165, height: 50)
                                    .overlay(
                                        Text(isProcessing ? ZipLiteral.RoomScan.processing : ZipLiteral.RoomScan.save)
                                            .foregroundStyle(Color.white)
                                    )
                            }
                            .disabled(isProcessing)
                            .onChange(of: model) { _, newModel in
                                if newModel != nil {
                                    if let newSpace = addSpace() {
                                        room = newSpace
                                        hasRoomModel = true
                                        showResultSheet = true
                                    }
                                    isProcessing = false
                                    // dismiss()
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            locationManager.requestLocationAuthorization()
            if let location = locationManager.userLocation {
                print("현재위치: \(location.latitude), \(location.longitude)")
            }
        }
        .sheet(isPresented: $showResultSheet) {
            if let room {
                ResultCardView(room: room, hasRoomModel: $hasRoomModel)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    //캡쳐된 모델이 보이는 뷰를 이미지로 캡쳐하기 위한 함수
    //3D모델이 존재하는 부분만 캡쳐되도록 영역을 조정해서 이미지로 만듦
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
                return
            }
            let outputImage = apply(mask: maskImage, to: inputImage)
            let image = render(ciImage: outputImage)
            DispatchQueue.main.async {
                self.model = image
            }
        }
    }
    
    //이미지의 배경을 제거하기 위한 Mask를 만들어주는 함수
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
    
    //이미지에 Mask를 적용하는 함수
    func apply(mask: CIImage, to image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        return filter.outputImage!
    }
    
    //이미지에 적용된 Mask에 따라 배경을 제거한 이미지를 리턴하는 함수
    func render(ciImage: CIImage) -> UIImage {
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else {
            fatalError("Failed to render CGImage")
        }
        return UIImage(cgImage: cgImage)
    }
    
    //SwiftData에 공간 정보를 저장하는 함수
    func addSpace() -> SampleRoom? {
        do {
            if let model, let location = locationManager.userLocation {
                let newSpace = SampleRoom(
                    id: UUID(),
                    mainPicture: mainPicture ?? UIImage(resource: .mainPicSample),
                    model: model.pngData()!,
                    latitude: location.latitude,
                    longitude: location.longitude
                )
                
                modelContext.insert(newSpace)
                room = newSpace
                try modelContext.save()
                return room
            }
        } catch {
            print("Failed to save data")
        }
        return nil
    }
}

//#Preview {
//    RoomScanView()
//}
