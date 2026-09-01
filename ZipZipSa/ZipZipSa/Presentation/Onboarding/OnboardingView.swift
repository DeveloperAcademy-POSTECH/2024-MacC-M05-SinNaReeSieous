//
//  OnboardingView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
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
        HStack(alignment: .center) {
            Text(ZipLiteral.Onboarding.onboardingGreetings[currentPage])
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            
            Spacer()
        }
        .background {
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, bottomTrailing: 10, topTrailing: 10))
                .fill(Color.Layer.first)
                .stroke(.black, lineWidth: 1)
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
                    // 관심 카테고리 선택은 체크리스트 템플릿으로 대체되면서 노출하지 않는다.
                    // CategorySelectView 코드는 그대로 두고 진입 경로만 막아둔 상태 —
                    // 되살리려면 아래 주석을 복구하고 Button을 걷어내면 된다.
                    //
                    // NavigationLink(destination: CategorySelectView()) {
                    //     RoundedRectangle(cornerRadius: 16)
                    //         .fill(Color.Button.primaryBlue)
                    //         .frame(width: UIScreen.screenSize.width - 32, height: 53)
                    //         .overlay {
                    //             Text(ZipLiteral.Onboarding.startButtonText)
                    //                 .foregroundStyle(Color.Text.primary)
                    //                 .applyZZSFont(zzsFontSet: .bodyBold)
                    //         }
                    // }
                    Button {
                        endOnboarding()
                    } label: {
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
                            if currentPage < ZipLiteral.Onboarding.onboardingGreetings.count - 1 {
                                currentPage += 1
                            }
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

    // MARK: - Action

    /// 온보딩 종료. 카테고리 선택 화면이 빠지면서 원래 그 화면이 하던
    /// User 생성 + firstLaunch 해제를 여기서 대신한다.
    func endOnboarding() {
        _ = UserService.fetchOrCreateUser(context: modelContext)
        guard (try? modelContext.save()) != nil else { return }
        firstLaunch = false
    }
}

#Preview {
    OnboardingView()
}
