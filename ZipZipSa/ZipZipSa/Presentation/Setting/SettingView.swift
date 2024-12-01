//
//  SettingView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    
    @Query var users: [User]
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.Background.primary
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
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
            .padding(.bottom, 27)
            .padding(.horizontal, 16)
    }
    
    var CustomDivider : some View {
        Rectangle()
            .fill(Color.Additional.seperator)
            .frame(width: UIScreen.screenSize.width, height: 1)
    }
    
    var CategoryChange: some View {
        NavigationLink(destination: CategoryChangeView()) {
            VStack(alignment: .leading, spacing: 0) {
                HStack{
                    Text(ZipLiteral.Setting.categoryChange)
                        .foregroundStyle(Color.Text.tertiary)
                        .applyZZSFont(zzsFontSet: .headline)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.Button.tertiary)
                        .applyZZSFont(zzsFontSet: .iconBody)
                }
                .padding(.bottom, 14)
                
                if userCategories.isEmpty {
                    CategoryEmtpyText
                        .padding(.bottom, 29)
                } else {
                    CategoryCellList
                        .padding(.bottom, 19)
                }
            }
            .padding(.horizontal, 16)
            
        }
    }
    
    var CategoryEmtpyText: some View {
        Text("선택한 카테고리가 없어요")
            .foregroundStyle(Color.Text.tertiary)
            .applyZZSFont(zzsFontSet: .caption1Regular)
    }
    
    var CategoryCellList: some View {
            HStack(spacing: 12) {
                ForEach(userCategories.indices, id: \.self) { index in
                    if let category = userCategories[safe: index] {
                        CategoryCell(for: category)
                    }
                }
            }
    }
    
    func CategoryCell(for category: ChecklistCategory) -> some View {
        Text(category.text)
            .applyZZSFont(zzsFontSet: .caption1Regular)
            .foregroundStyle(Color.Text.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.ChecklistTag.backgroundYellow)
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
    
    // MARK: - Computed Values
    
    var userCategories: [ChecklistCategory] {
        return users[0].favoriteCategories
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
