//
//  RoomPlanManager.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI
import RoomPlan

class RoomPlanManager: RoomCaptureViewDelegate {
    func encode(with coder: NSCoder) {
        fatalError("Not Needed")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Needed")
    }
    
    static var shared = RoomPlanManager()
    
    var captureView: RoomCaptureView
    var sessionConfig: RoomCaptureSession.Configuration
    var finalResult: CapturedRoom?
    
    private init() {
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
    //뷰를 생성하고 초기화하는 함수
    func makeUIView(context: Context) -> RoomCaptureView {
        RoomPlanManager.shared.captureView
    }
    
    func updateUIView(_ uiView: RoomCaptureView, context: Context) {
        
    }
}
