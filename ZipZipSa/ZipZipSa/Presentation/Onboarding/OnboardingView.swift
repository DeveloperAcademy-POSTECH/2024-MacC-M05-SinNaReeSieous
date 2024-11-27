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
        NavigationStack {
            VStack(spacing: 0){
                OnboardingMessageBubble
                OnboardingImage
                Spacer()
                OnboardingButton
            }
        }
        .accentColor(Color.Button.tertiary)
    }
}

private extension OnboardingView {
    
    var OnboardingMessageBubble: some View {
        GeometryReader { geometry in
            Text(onboardingGreetings[currentPage])
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .background(Color.white)
                .overlay {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, bottomTrailing: 10, topTrailing: 10))
                        .stroke(.black, lineWidth: 1)
                        .frame(width: UIScreen.screenSize.width - 48)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // 중심축 고정
        }
        .frame(width: UIScreen.screenSize.width - 32, height: UIScreen.screenSize.height / 812 * 100)
        .accentColor(Color.Button.tertiary)
        .padding(.top, 140)
    }
    
    var OnboardingImage: some View {
        Image(onboardingImages[currentPage])
            .border(.black, width: 1)
        
    }
    
    var OnboardingButton: some View {
        NavigationStack {
            VStack {
                if currentPage == onboardingGreetings.count - 1 {
                    NavigationLink(destination: CategorySelectView()) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.Button.primaryBlue)
                            .frame(width: UIScreen.screenSize.width - 32, height: 53)
                            .overlay {
                                Text("시작하기")
                                    .applyZZSFont(zzsFontSet: .bodyBold)
                                    .foregroundColor(.black)
                            }
                    }
                } else {
                    Button {
                        withAnimation {
                            currentPage += 1
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.Button.primaryBlue)
                            .frame(width: UIScreen.screenSize.width - 32, height: 53)
                            .overlay {
                                Text("계속하기")
                                    .applyZZSFont(zzsFontSet: .bodyBold)
                                    .foregroundColor(.black)
                            }
                    }
                }
            }
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    OnboardingView()
}
