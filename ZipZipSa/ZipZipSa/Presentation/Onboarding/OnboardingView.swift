//
//  OnboardingView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onboardingGreetings = [
        "안녕하세요.\n저는 용궁에서 올라온 거북이, 용북이에요!",
        "저와 함께라면 빠르고 꼼꼼하게 \n집을 살펴볼 수 있어요.",
        "주인님이 집을 볼 때, 어디를 더 신경써서 \n보고싶은지 알려주세요. 주인님의 선호에 \n맞게 체크리스트를 준비할게요!",
        "그럼 바로 시작할까요?"
    ]
    let onboardingImages = ["helloYongboogiFullColor", "smileYongboogiFullColor", "writingYongboogiFullColor", "winkingYongboogiFullColor"]
    
    var body: some View {
        VStack(spacing: 0){
            OnboardingMessageBubble
            OnboardingImage
            Spacer()
            OnboardingButton
        }
    }
}

private extension OnboardingView {
    
    var OnboardingMessageBubble: some View {
        VStack {
            Text(onboardingGreetings[currentPage])
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .font(Font.system (size: 18, weight: .semibold))
                .background(Color.white)
                .overlay {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, bottomTrailing: 10, topTrailing: 10))
                        .stroke(.black, lineWidth: 1)
                        .frame(width: UIScreen.screenSize.width - 48)
                }
        }
        .padding(.top, 200)
        .padding(.bottom, 48)
    }
    
    var OnboardingImage: some View {
        Image(onboardingImages[currentPage])
    }
    
    var OnboardingButton: some View {
        VStack {
            Button {
                // 마지막 페이지가 아닐 경우에만 다음 페이지로 이동
                if currentPage < onboardingGreetings.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: UIScreen.screenSize.width - 32, height: 53)
                    .overlay {
                        Text(currentPage == onboardingGreetings.count - 1 ? "시작하기" : "계속하기")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    }
            }
        }
        .padding(.bottom, 32)
    }
}

#Preview {
    OnboardingView()
}
