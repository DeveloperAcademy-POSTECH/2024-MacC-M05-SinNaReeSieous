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
            ZStack{
                Color.Background.primary
                    .ignoresSafeArea()
                VStack(spacing: 0){
                    Spacer().frame(height: UIScreen.screenSize.height/812*130)
                    MessageBubble
                    GreetingYongboogiImage
                    Spacer().frame(height: UIScreen.screenSize.height/812*160)
                    ContinueAndStartButton
                        .padding(.bottom, UIScreen.isSe ? 30 : 0)
                }
            }
        }
    }
}

private extension OnboardingView {
    
    var MessageBubble: some View {
        Text(ZipLiteral.Onboarding.onboardingGreetings[currentPage])
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyBold)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, bottomTrailing: 10, topTrailing: 10))
                    .fill(Color.Layer.first)
                    .stroke(.black, lineWidth: 1)
                    .frame(width: UIScreen.screenSize.width - 48)
            }
        .frame(width: UIScreen.screenSize.width - 48, height: 96)
        .padding(.bottom, 16)
    }
    
    var GreetingYongboogiImage: some View {
        Image(onboardingImages[currentPage])
    }
    
    var ContinueAndStartButton: some View {
        NavigationStack {
            VStack {
                if currentPage == ZipLiteral.Onboarding.onboardingGreetings.count - 1 {
                    NavigationLink(destination: CategorySelectView()) {
                        RoundedRectangle(cornerRadius: 16)
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
                        RoundedRectangle(cornerRadius: 16)
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
            .padding(.bottom, 12)
        }
    }
}

#Preview {
    OnboardingView()
}
