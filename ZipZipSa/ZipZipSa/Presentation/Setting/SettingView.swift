//
//  SettingView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct SettingView: View {
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.Background.primary
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    NavigationTitle
                    CategoryChange
                    CustomDivider
                    PrivacyPolicy
                    Support
                    Spacer()
                    AppVersion
                }
            }
        }
    }
}

private extension SettingView {
    // MARK: - View
    
    var NavigationTitle: some View {
        Text(ZipLiteral.Setting.setting)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
    }
    
    var CustomDivider : some View {
        Rectangle()
            .fill(Color.Additional.seperator)
            .frame(width: UIScreen.screenSize.width, height: 2)
    }
    
    var CategoryChange: some View {
        NavigationLink(destination: CategoryChangeView()) {
            VStack(alignment:.leading, spacing:12) {
                HStack{
                    Text(ZipLiteral.Setting.categoryChange)
                        .foregroundStyle(Color.Text.tertiary)
                        .applyZZSFont(zzsFontSet: .headline)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.Button.tertiary)
                        .applyZZSFont(zzsFontSet: .iconBody)
                }
                
                CategoryCellList
            }
            .padding(.horizontal, 16)
            .padding(.top, 13)
            .padding(.bottom, 20)
        }
    }
    
    var CategoryCellList: some View {
        HStack (spacing: 12) {
            ForEach(OnboardingCategory.categories, id: \.categoryElement) { category in
                CategoryCell(for: category)
            }
        }
    }
    
    func CategoryCell(for category: OnboardingCategory) -> some View {
        Text(categoryDisplayName(for: category.categoryElement))
            .applyZZSFont(zzsFontSet: .caption1Regular)
            .foregroundStyle(Color.Text.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.ChecklistTag.backgroundYellow)
            }
    }
    
    func categoryDisplayName(for element: String) -> String {
        switch element {
        case "InsectProof": return "방충"
        case "Cleenliness": return "청결"
        case "Security": return "보안"
        case "Ventilation": return "환기"
        case "Soundproof": return "방음"
        case "Lighted": return "채광"
        default: return ""
        }
    }
    
    var PrivacyPolicy: some View {
        Link(destination: URL(string: "https://jinthelemon.notion.site/14e90636549f80ecb267dd7a429dd9a4")!, label: {
            HStack{
                Text(ZipLiteral.Setting.privacyPolicy)
                    .foregroundStyle(Color.Text.tertiary)
                    .applyZZSFont(zzsFontSet: .headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.Button.tertiary)
                    .applyZZSFont(zzsFontSet: .iconBody)
            }
            .padding()
        })
    }
    
    var Support: some View {
        Link(destination: URL(string: "https://jinthelemon.notion.site/c9a91e1e9a56481d9e4084575426e370")!, label: {
            HStack{
                Text(ZipLiteral.Setting.support)
                    .foregroundStyle(Color.Text.tertiary)
                    .applyZZSFont(zzsFontSet: .headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.Button.tertiary)
                    .applyZZSFont(zzsFontSet: .iconBody)
            }
            .padding()
        })
    }
    
    var AppVersion: some View {
        HStack {
            Spacer()
            Text(appVersion)
                .applyZZSFont(zzsFontSet: .footnote)
                .foregroundStyle(Color.Text.placeholder)
                .padding()
            Spacer()
        }
    }
    
    // MARK: - Computed Value
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return "현재 버전: \(version)"
    }
}

#Preview {
    SettingView()
}
