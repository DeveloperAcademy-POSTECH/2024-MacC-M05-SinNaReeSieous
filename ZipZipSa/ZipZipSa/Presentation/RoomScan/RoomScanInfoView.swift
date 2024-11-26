//
//  RoomScanInfoView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/27/24.
//

import SwiftUI

struct RoomScanInfoView: View {
    @Binding var isSessionStarted: Bool
    
    var body: some View {
        ZStack {
            CameraViewRepresentable()
                .ignoresSafeArea()
                .blur(radius: 6)
            
            VStack {
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 1)) {
                        isSessionStarted = true
                    }
                } label: {
                    Text("시작하기")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}
