//
//  RoomScanView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import RoomPlan

struct RoomScanView: View {
    @State private var doneScanning: Bool = false
    @State private var capturedView: UIImage?
    @State private var model: UIImage?
    @State private var showResultSheet: Bool = false
    @State private var isProcessing: Bool = false
    @State private var isSessionStarted: Bool = false
    let roomController = RoomPlanManager.shared
    
    var body: some View {
        if !isSessionStarted {
            checkDeciveView()
        } else {
            roomCaptureView
                .onChange(of: model) { _, newModel in
                    if newModel != nil {
                        showResultSheet = true
                        isProcessing = false
                    }
                }
                .sheet(isPresented: $showResultSheet) {
                    // TODO: ResultCardView로 교체
                    modelPreview
                }
        }
    }
}

private extension RoomScanView {
    // MARK: - View
    
    var roomCaptureView: some View {
        ZStack {
            RoomCaptureViewRepresentable()
                .onAppear {
                    roomController.startSession()
                }
                .onDisappear {
                    roomController.stopSession()
                }
                .ignoresSafeArea()
            
            if doneScanning {
                doneScanningView
            } else {
                scanningView
            }
        }
    }
    
    var doneScanningView: some View {
        DoneScanningView(capturedView: $capturedView, model: $model, isProcessing: $isProcessing, showResultSheet: $showResultSheet, doneScanning: $doneScanning)
    }
    
    var scanningView: some View {
        ScanningView(doneScanning: $doneScanning)
    }
    
    var modelPreview: some View {
        VStack {
            if let modelData = model {
                Image(uiImage: modelData)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .scaledToFit()
            } else {
                Text("모델이 없습니다.")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    // MARK: - Computed Values
    
    @ViewBuilder
    func checkDeciveView() -> some View {
        if RoomCaptureSession.isSupported {
            RoomScanInfoView(isSessionStarted: $isSessionStarted)
        } else {
            UnsupportedDeviceView()
        }
    }
}

#Preview {
    RoomScanView()
}
