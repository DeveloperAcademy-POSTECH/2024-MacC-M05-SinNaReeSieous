//
//  AddressEnterView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/29/24.
//

import SwiftUI

struct AddressEnterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar
                
                Spacer()
            }
            .background(Color.Background.primary)
            .navigationTitle("주소 찾기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CancelButton
                }
            }
        }
    }
}

private extension AddressEnterView {
    
    // MARK: - View
    
    var SearchBar: some View {
        HStack(spacing: 4) {
            TextField(text: $searchText) {
                Text("주소를 알려주세요(예: 학교, 회사)")
                    .foregroundStyle(Color.Text.placeholder)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
            
            Button {
                print("Search")
                //                Task {
                //                    await fetchSearchResults(for: searchText)
                //                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.Icon.tertiary)
                    .font(.system(size: 18, weight: .regular))
                    .padding(4)
            }
        }
        .padding(.leading, 12)
        .padding(.trailing, 8)
        .frame(height: 48)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Button.enable)
        }
        .padding(.top, 14)
        .padding(.horizontal, 16)
    }
    
    
    var CancelButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("취소")
                .foregroundStyle(Color.Text.tertiary)
                .applyZZSFont(zzsFontSet: .bodyRegular)
        }
    }
}

#Preview {
    AddressEnterView()
}
