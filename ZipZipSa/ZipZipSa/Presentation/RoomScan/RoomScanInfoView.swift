//
//  RoomScanInfoView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/27/24.
//

import SwiftUI

struct RoomScanInfoView: View {
    @Binding var isSessionStarted: Bool
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            cameraView
            VStack {
                Spacer()
                characterImage
                InfoTitle
                InfoDescription
                Spacer()
                bottomButtons
            }
        }
        .alert("집 구조 기록 건너뛰기", isPresented: $showAlert) {
            Button("취소") { }
            
            Button("확인") {
                // TODO: 모델 이미지가 없는 상태로 결과지 시트 띄우기
            }
        } message: {
            Text("구조 기록을 하지않고\n 바로 결과지 화면으로 넘어갑니다.")
        }
    }
}

private extension RoomScanInfoView {
    // MARK: - View
    
    var cameraView: some View {
        CameraViewRepresentable()
            .overlay {
                Rectangle()
                    .fill(Color.black.opacity(0.4))
            }
            .blur(radius: 6)
            .ignoresSafeArea()
    }
    
    var characterImage: some View {
        Image(.charRoomScanInfo)
            .resizable()
            .scaledToFit()
            .frame(width: 95, height: 86)
            .padding(.bottom, 48)
    }
    
    var InfoTitle: some View {
        Text("집 구조만 기록해요")
            .foregroundStyle(Color.Text.onColorPrimary)
            .font(.title.bold())
            .padding(.bottom, 36)
        // .applyZZSFont(zzsFontSet: .title1)
    }
    
    var InfoDescription: some View {
        VStack {
            Group {
                Text("아이폰 내장 기술인 RoomPlan을 사용해")
                Text("집의 구조를 기록할 거예요.")
                    .padding(.bottom)
            }
            .foregroundStyle(Color.Text.onColorPrimary)
            .font(.body.bold())
            // .applyZZSFont(zzsFontSet: .bodyRegular)
            
            Group {
                Text("3d 모델 형태로 집 구조가 제공되며,")
                Text("이 과정에서 사진 정보는 기록되지 않아요.")
            }
            .foregroundStyle(Color.Text.onColorPrimary)
            .font(.body.bold())
            // .applyZZSFont(zzsFontSet: .bodyRegular)
        }
    }
    
    var bottomButtons: some View {
        VStack {
            Button {
                withAnimation(.easeInOut(duration: 1)) {
                    isSessionStarted = true
                }
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.Button.primaryBlue)
                    .frame(height: 53)
                    .overlay(
                        Text("시작하기")
                            .foregroundStyle(Color.Text.primary)
                            // .applyZZSFont(zzsFontSet: .bodyBold)
                    )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 22)
            
            Button {
                showAlert = true
            } label: {
                Text("건너뛰기")
                    .foregroundStyle(Color.Text.onColorSecondary)
                    .font(.body.bold())
                // .applyZZSFont(zzsFontSet: .bodyBold)
            }
            .padding(.bottom, 35)
        }
    }
}
