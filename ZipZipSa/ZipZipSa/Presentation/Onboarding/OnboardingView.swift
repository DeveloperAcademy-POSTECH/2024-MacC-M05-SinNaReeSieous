//
//  OnboardingView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onboardingImages = ["helloYongboogiFullColor", "smileYongboogiFullColor", "writingYongboogiFullColor", "winkingYongboogiFullColor"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                MessageBubble
                GreetingYongboogiImage
                Spacer()
                ContinueAndStartButton
            }
        }
        .accentColor(Color.Button.tertiary)
    }
}

private extension OnboardingView {
    
    var MessageBubble: some View {
        GeometryReader { geometry in
            Text(ZipLiteral.Onboarding.onboardingGreetings[currentPage])
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
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
    
    var GreetingYongboogiImage: some View {
        Image(onboardingImages[currentPage])
            .padding(.top, 28)
    }
    
    var ContinueAndStartButton: some View {
        NavigationStack {
            VStack {
                if currentPage == ZipLiteral.Onboarding.onboardingGreetings.count - 1 {
                    NavigationLink(destination: CategorySelectView()) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.Button.primaryBlue)
                            .frame(width: UIScreen.screenSize.width - 32, height: 53)
                            .overlay {
                                Text(ZipLiteral.Onboarding.startButtonText)
                                    .foregroundStyle(Color.Text.primary)
                                    .applyZZSFont(zzsFontSet: .bodyBold)
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
                                Text(ZipLiteral.Onboarding.continueButtonText)
                                    .foregroundStyle(Color.Text.primary)
                                    .applyZZSFont(zzsFontSet: .bodyBold)
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
