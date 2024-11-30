//
//  RoomScanView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import RoomPlan

struct RoomScanView: View {
    @StateObject private var roomManager = RoomPlanManager()
    @State private var doneScanning: Bool = false
    @State private var capturedView: UIImage?
    @Binding var model: UIImage?
    @State private var showResultSheet: Bool = false
    @State private var isProcessing: Bool = false
    @Binding var homeData: HomeData
    @Binding var showHomeHuntSheet: Bool
    
    var body: some View {
        RoomCaptureView
            .onChange(of: model) { _, newModel in
                if newModel != nil {
                    showResultSheet = true
                    isProcessing = false
                }
            }
            .fullScreenCover(isPresented: $showResultSheet) {
                ResultCardView(model: $model, homeData: $homeData, showHomeHuntSheet: $showHomeHuntSheet)
                    .presentationDragIndicator(.visible)
            }
    }
}

private extension RoomScanView {
    // MARK: - View
    
    var RoomCaptureView: some View {
        ZStack {
            RoomCaptureViewRepresentable(manager: roomManager)
                .onAppear {
                    roomManager.startSession()
                }
                .onDisappear {
                    roomManager.stopSession()
                }
                .ignoresSafeArea()
            
            if doneScanning {
                DoneScanningView(
                    capturedView: $capturedView,
                    model: $model,
                    isProcessing: $isProcessing,
                    showResultSheet: $showResultSheet,
                    doneScanning: $doneScanning,
                    roomManager: roomManager
                )
            } else {
                ScanningView(doneScanning: $doneScanning, roomManager: roomManager)
            }
        }
    }
    
    var ModelPreview: some View {
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
    
    
}
