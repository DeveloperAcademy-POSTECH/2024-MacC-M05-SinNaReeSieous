////
////  TestAddressEnterView.swift
////  ZipZipSa
////
////  Created by 조우현 on 11/30/24.
////
//
//import SwiftUI
//import CoreLocation
//import MapKit   // ✅
//
//struct AddressEnterView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    
//    @State private var searchText: String = ""
//    @State private var selectedCoordinates: CLLocationCoordinate2D?
//    @State private var isLoading: Bool = false
//    @State private var errorMessage: String? = nil
//    /*@State private var searchResults: [(description: String, placeID: String)] = []*/ // ❌
//    @FocusState private var focusedTextField: AddressEnterFocusField?
//    @Binding var resultCoordinates: CLLocationCoordinate2D?
//    @Binding var resultLocationText: String?
//    
//    @State private var searchResults: [MKMapItem] = []  // ✅
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                SearchBar
//                if isLoading {
//                    Spacer()
//                    ProgressView("검색 중...")
//                } else if errorMessage != nil {
//                    Spacer()
//                    ErrorMessage
//                } else {
//                    SearchResultList
//                }
//                Spacer()
//                CompleteButton
//            }
//            .background(Color.Background.primary)
//            .dismissKeyboard()
//            .navigationTitle("주소 찾기")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    CancelButton
//                }
//            }
//            .onAppear {
//                focusedTextField = .searchBar
//            }
//        }
//    }
//}
//
//private extension AddressEnterView {
//    
//    // MARK: - View
//    
//    var SearchBar: some View {
//        HStack(spacing: 4) {
//            TextField(text: $searchText) {
//                Text("집 주소를 입력해 주세요.")
//                    .foregroundStyle(Color.Text.placeholder)
//                    .applyZZSFont(zzsFontSet: .bodyRegular)
//            }
//            .foregroundStyle(Color.Text.primary)
//            .applyZZSFont(zzsFontSet: .bodyRegular)
//            .focused($focusedTextField, equals: .searchBar)
//            .onSubmit {
//                Task {
//                    await testSearchAddress(searchText) // ✅
//                    print(searchResults)
//                }
//            }
//            
//            Button {
//                print("Search")
//                Task {
//                    await testSearchAddress(searchText) // ✅
//                    print(searchResults)
//                }
//            } label: {
//                Image(systemName: "magnifyingglass")
//                    .foregroundStyle(Color.Icon.tertiary)
//                    .font(.system(size: 18, weight: .regular))
//                    .padding(4)
//            }
//        }
//        .padding(.leading, 12)
//        .padding(.trailing, 8)
//        .frame(height: 48)
//        .background {
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.Button.enable)
//        }
//        .padding(.top, 14)
//        .padding(.horizontal, 16)
//    }
//    
//    var SearchResultList: some View {
//        ScrollView {
//            VStack(spacing: 0) {
//                ForEach(searchResults, id: \.self) { result in  // ✅
//                    Button {
//                        print("Taaped")
//                        if let coordinate = result.placemark.location?.coordinate { // ✅
//                            selectedCoordinates = coordinate
//                            searchText = result.name ?? "선택된 주소"
//                            print("선택된 좌표: \(coordinate.latitude), \(coordinate.longitude)")
//                        }
//                    } label: {
//                        VStack(alignment: .leading, spacing: 0) {
//                            if let addressLine = formatAddress(from: result.placemark) {    // ✅
//                                Text(addressLine)
//                                    .foregroundStyle(Color.Text.primary)
//                                    .applyZZSFont(zzsFontSet: .bodyRegular)
//                                    .multilineTextAlignment(.leading)
//                                    .padding(.horizontal, 8)
//                                    .padding(.vertical, 12)
//                            }
//                            Rectangle()
//                                .fill(Color.Additional.seperator)
//                                .frame(height: 1)
//                        }
//                    }
//                }
//            }
//            .padding(.horizontal, 16)
//            .padding(.top, 16)
//        }
//        .scrollIndicators(.hidden)
//    }
//    
//    var ErrorMessage: some View {
//        Text(errorMessage ?? "")
//            .foregroundStyle(Color.Text.tertiary)
//            .multilineTextAlignment(.center)
//            .applyZZSFont(zzsFontSet: .bodyRegular)
//    }
//    
//    var CancelButton: some View {
//        Button {
//            cancelSearch()
//        } label: {
//            Text("취소")
//                .foregroundStyle(Color.Text.tertiary)
//                .applyZZSFont(zzsFontSet: .bodyRegular)
//        }
//    }
//    
//    var CompleteButton: some View {
//        ZZSMainButton(
//            action: { applySearchResult() },
//            text: "완료"
//        )
//        .padding(.bottom, 12)
//        .padding([.horizontal, .top], 16)
//    }
//    
//    // MARK: - Action
//    
//    func applySearchResult() {
//        self.presentationMode.wrappedValue.dismiss()
//        if selectedCoordinates != nil && !searchText.isEmpty {
//            self.resultCoordinates = selectedCoordinates
//            self.resultLocationText = searchText
//        }
//    }
//    
//    func cancelSearch() {
//        self.presentationMode.wrappedValue.dismiss()
//    }
//    
//    
//    // MARK: - Custom Method
//    
////    private func fetchSearchResults(for query: String) async { ❌
////        isLoading = true
////        errorMessage = nil
////        
////        do {
////            let results = try await AddressSearchManager.shared.fetchAutocompleteResults(for: query)
////            searchResults = results
////            isLoading = false
////            if results.isEmpty {
////                errorMessage = "검색 결과가 없어요\n이름을 다시 확인해주세요"
////            }
////        } catch {
////            errorMessage = "검색 실패: \(error.localizedDescription)"
////            isLoading = false
////        }
////    }
//    
////    private func selectAddress(_ result: (description: String, placeID: String)) async { ❌
////        errorMessage = nil
////        
////        do {
////            let coordinates = try await AddressSearchManager.shared.fetchCoordinates(for: result.placeID)
////            selectedCoordinates = coordinates
////            searchText = result.description
////        } catch {
////            errorMessage = "위치 정보를 가져올 수 없습니다."
////        }
////    }
//    
//    // MARK: - Test ✅
//    
//    private func testSearchAddress(_ query: String) async {
//        guard !query.isEmpty else {
//            await MainActor.run {
//                searchResults = []
//            }
//            return
//        }
//        
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = query
//        
//        let search = MKLocalSearch(request: request)
//        do {
//            let response = try await search.start()
//            await MainActor.run {
//                self.searchResults = response.mapItems.uniqued()
//            }
//        } catch {
//            print("주소 검색 실패: \(error.localizedDescription)")
//        }
//    }
//    
//    private func formatAddress(from placemark: MKPlacemark) -> String? {
//        let administrativeArea = placemark.administrativeArea ?? "" // 도/광역시
//        let locality = placemark.locality ?? "" // 시/군/구
//        let thoroughfare = placemark.thoroughfare ?? "" // 도로명
//        let subThoroughfare = placemark.subThoroughfare ?? "" // 도로번호
//        
//        let formattedLocality = locality == administrativeArea ? "" : locality
//        
//        let components = [administrativeArea, formattedLocality, thoroughfare, subThoroughfare]
//        let address = components
//            .filter { !$0.isEmpty }
//            .joined(separator: " ")
//        
//        return address.isEmpty ? nil : address
//    }
//}
//
//enum AddressEnterFocusField {
//    case searchBar
//}
//
//
//
////#Preview {
////    TestAddressEnterView()
////}
