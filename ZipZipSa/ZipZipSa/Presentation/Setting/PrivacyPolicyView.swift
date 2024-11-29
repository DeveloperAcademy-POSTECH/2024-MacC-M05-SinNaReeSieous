//
//  PrivacyPolicyView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/29/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Color.Background.primary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    NavigationTitle
                    Content
                }
                .padding(.horizontal, 16)
            }
            .clipped()
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

private extension PrivacyPolicyView {
    
    var NavigationTitle: some View {
        Text(ZipLiteral.PrivacyPolicy.privacyPolicy)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
            .padding(.bottom, 12)
    }
    
    var Content: some View {
        VStack(alignment: .leading, spacing: 32) {
            ForEach(0...10, id: \.self) { index in
                VStack(alignment: .leading, spacing: 12) {
                    Text(termsTitle(for: index))
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .headline)
                    
                    Text(termsBody(for: index))
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                }
            }
        }
        .padding(.bottom, 43)
    }
    
    private func termsTitle(for index: Int) -> String {
        switch index {
        case 1: return ZipLiteral.PrivacyPolicy.textTitle1
        case 2: return ZipLiteral.PrivacyPolicy.textTitle2
        case 3: return ZipLiteral.PrivacyPolicy.textTitle3
        case 4: return ZipLiteral.PrivacyPolicy.textTitle4
        case 5: return ZipLiteral.PrivacyPolicy.textTitle5
        case 6: return ZipLiteral.PrivacyPolicy.textTitle6
        case 7: return ZipLiteral.PrivacyPolicy.textTitle7
        case 8: return ZipLiteral.PrivacyPolicy.textTitle8
        case 9: return ZipLiteral.PrivacyPolicy.textTitle9
        case 10: return ZipLiteral.PrivacyPolicy.textTitle10
        default: return ""
        }
    }
    
    private func termsBody(for index: Int) -> String {
        switch index {
        case 0: return ZipLiteral.PrivacyPolicy.textBody0
        case 1: return ZipLiteral.PrivacyPolicy.textBody1
        case 2: return ZipLiteral.PrivacyPolicy.textBody2
        case 3: return ZipLiteral.PrivacyPolicy.textBody3
        case 4: return ZipLiteral.PrivacyPolicy.textBody4
        case 5: return ZipLiteral.PrivacyPolicy.textBody5
        case 6: return ZipLiteral.PrivacyPolicy.textBody6
        case 7: return ZipLiteral.PrivacyPolicy.textBody7
        case 8: return ZipLiteral.PrivacyPolicy.textBody8
        case 9: return ZipLiteral.PrivacyPolicy.textBody9
        case 10: return ZipLiteral.PrivacyPolicy.textBody10
        default: return ""
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
