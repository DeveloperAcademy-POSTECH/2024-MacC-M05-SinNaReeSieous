//
//  RoomPlanManager.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI
import RoomPlan
import AVFoundation

class RoomPlanManager: RoomCaptureViewDelegate, ObservableObject {
    func encode(with coder: NSCoder) {
        fatalError("Not Needed")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Needed")
    }
    
    var captureView: RoomCaptureView
    var sessionConfig: RoomCaptureSession.Configuration
    var finalResult: CapturedRoom?
    
    init() {
        captureView = RoomCaptureView(frame: .zero)
        sessionConfig = RoomCaptureSession.Configuration()
        captureView.delegate = self
    }
    
    // 캡쳐가 완료되었는지 아닌지에 대해서 Bool 값을 리턴하는 함수
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: (Error)?) -> Bool {
        return true
    }
    
    // 캡쳐가 완료된 결과를 finalResult에 저장하는 함수
    func captureView(didPresent processedResult: CapturedRoom, error: (Error)?) {
        finalResult = processedResult
    }
    
    // 캡쳐를 시작하는 함수
    func startSession() {
        captureView.captureSession.run(configuration: sessionConfig)
    }
    
    // 캡쳐를 종료하는 함수
    func stopSession() {
        captureView.captureSession.stop()
    }
}

// UIKit 뷰를 SwiftUI에서 보여지도록 UIViewRepresentable 프로토콜을 사용
struct RoomCaptureViewRepresentable : UIViewRepresentable {
    let manager: RoomPlanManager
    
    func makeUIView(context: Context) -> RoomCaptureView {
        manager.captureView
    }
    
    func updateUIView(_ uiView: RoomCaptureView, context: Context) { }
}

struct CameraViewRepresentable: UIViewRepresentable {
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraViewRepresentable
        
        init(parent: CameraViewRepresentable) {
            self.parent = parent
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            return view
        }
        
        captureSession.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
