//
//  CategorySelectView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/24/24.
//

import SwiftUI
import SwiftData

struct CategorySelectView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var totalTime: Int = 10
    @State private var currentMessage: String = ""
    @State private var selectedCategory: Set<ChecklistCategory> = []
    
    var body: some View {
        ZStack {
            Color.Background.primary
                .ignoresSafeArea()
            VStack(spacing: 0) {
                ZipZipSaTip
                RequiredTime
                Spacer()
                CategoryView(
                    totalTime: $totalTime,
                    currentMessage: $currentMessage,
                    selectedCategories: $selectedCategory)
                Spacer()
                BottomButton
            }
        }
        .navigationBarBackButtonHidden()
    }
}

private extension CategorySelectView {
    
    var ZipZipSaTip: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Image("basicYongboogiBowtieHeadColor")
                .resizable()
                .scaledToFit()
                .frame(width: 62, height: 62)
                .padding(.leading, 8)
                .padding(.trailing, 18)
            
            Group {
                if currentMessage.isEmpty {
                    Text(ZipLiteral.CategorySelect.defaultMessage)
                } else {
                    Text(currentMessage)
                }
            }
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .subheadlineBold)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(width: UIScreen.screenSize.width - 120, alignment: .bottomLeading)
            .background {
                GeometryReader { geometry in
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(
                        topLeading: 10,
                        bottomTrailing: 10,
                        topTrailing: 10
                    ))
                    .stroke(.black, lineWidth: 1)
                    .fill(Color.Layer.first)
                    .frame(width: UIScreen.screenSize.width - 120)
                }
            }
        }
        .frame(width: UIScreen.screenSize.width - 32, height: UIScreen.screenSize.height / 812 * 116, alignment: .bottom)
        .padding(.bottom, 24)
    }
    
    var RequiredTime: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.Background.secondary)
            .frame(width:UIScreen.screenSize.width - 32, height: 44)
            .overlay {
                HStack(alignment: .center) {
                    Text(ZipLiteral.CategorySelect.requiredTime)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .footnote)
                    
                    Text("약 \(totalTime)분")
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyBold)
                }
            }
    }
    
    var BottomButton: some View {
        Button {
            endOnboarding()
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Button.primaryBlue)
                .frame(width:UIScreen.screenSize.width - 32, height: 53)
                .overlay {
                    Text(ZipLiteral.CategorySelect.done)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet:.bodyBold)
                }
        }
        .padding(.bottom, 12)
    }
    
    // MARK: - Action
    
    func endOnboarding() {
        let checklistCategoryData = selectedCategory.map {
            ChecklistCategoryData(rawValue: $0.rawValue)
        }
        let user = User(favoriteCategoryData: checklistCategoryData)
        print(user.favoriteCategories)
        modelContext.insert(user)
        guard let _ = try? modelContext.save() else  {
            return
        }
        firstLaunch = false
    }
}

#Preview {
    CategorySelectView()
}
