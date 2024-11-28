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
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var searchResults: [(description: String, placeID: String)] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar
                
                if isLoading {
                    ProgressView("검색 중...")
                } else if errorMessage != nil {
                    Spacer()
                    ErrorMessage
                } else {
                    List(searchResults, id: \.placeID) { result in
                        Button {
                            print("Tapped")
//                            Task {
//                                await selectAddress(result)
//                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(result.description)
                                    .foregroundStyle(Color.Text.primary)
                                    .applyZZSFont(zzsFontSet: .bodyRegular)
                                
                                Rectangle()
                                    .fill(Color.Additional.seperator)
                                    .frame(height: 1)
                            }
                            .background(Color.clear)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 12, leading: 8, bottom: 0, trailing: 8))
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .padding(16)
                }
                Spacer()
            }
            .background(Color.Background.primary)
            .dismissKeyboard()
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
                Text("집 주소를 입력해 주세요.")
                    .foregroundStyle(Color.Text.placeholder)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
            
            Button {
                print("Search")
                Task {
                    await fetchSearchResults(for: searchText)
                    print(searchResults)
                }
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
    
    var ErrorMessage: some View {
        Text(errorMessage ?? "")
            .foregroundStyle(Color.Text.tertiary)
            .multilineTextAlignment(.center)
            .applyZZSFont(zzsFontSet: .bodyRegular)
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
    
    
    // MARK: - Custom Method
    
    private func fetchSearchResults(for query: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await AddressSearchManager.shared.fetchAutocompleteResults(for: query)
            searchResults = results
            isLoading = false
            if results.isEmpty {
                errorMessage = "검색 결과가 없어요\n이름을 다시 확인해주세요"
            }
        } catch {
            errorMessage = "검색 실패: \(error.localizedDescription)"
            isLoading = false
        }
    }
}

#Preview {
    AddressEnterView()
}
