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
    let roomController = RoomPlanManager.shared
    
    var body: some View {
        ZStack {
            roomCaptureView
            if doneScanning {
                doneScanningView
            } else {
                scanningView
            }
        }
        .onChange(of: model) { _, newModel in
            if newModel != nil {
                showResultSheet = true
                isProcessing = false
            }
        }
        .sheet(isPresented: $showResultSheet) {
            // TODO: ResultCardView로 교체
            if let modelData = model {
                Image(uiImage: modelData)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .scaledToFit()
            }
        }
    }
}

private extension RoomScanView {
    // MARK: - View
    
    var roomCaptureView: some View {
        RoomCaptureViewRepresentable()
            .onAppear {
                roomController.startSession()
            }
            .onDisappear {
                roomController.stopSession()
            }
            .ignoresSafeArea()
    }
    
    var doneScanningView: some View {
        DoneScanningView(capturedView: $capturedView, model: $model, isProcessing: $isProcessing, showResultSheet: $showResultSheet, doneScanning: $doneScanning)
    }
    
    var scanningView: some View {
        ScanningView(doneScanning: $doneScanning)
    }
}

#Preview {
    RoomScanView()
}
