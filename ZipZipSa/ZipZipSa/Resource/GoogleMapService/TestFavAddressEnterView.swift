////
////  TestFavAddressEnterView.swift
////  ZipZipSa
////
////  Created by 조우현 on 11/25/24.
////
//
//import SwiftUI
//import CoreLocation
//import SwiftData
//
//struct TestFavAddressEnterView: View {
//    
//    @Environment(\.modelContext) private var modelContext
//    @State private var searchText: String = ""
//    @State private var searchResults: [(description: String, placeID: String)] = []
//    @State private var selectedCoordinates: CLLocationCoordinate2D?
//    @State private var isNextButtonActive = false
//    @State private var isLoading = false
//    @State private var errorMessage: String?
//    
//    var body: some View {
//        VStack {
//            HStack {
//                TextField("주소를 알려주세요(예: 학교, 회사)", text: $searchText)
//                    .padding()
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .autocapitalization(.none)
//                    .disableAutocorrection(true)
//                
//                Button {
//                    Task {
//                        await fetchSearchResults(for: searchText)
//                    }
//                } label: {
//                    Text("검색")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .disabled(searchText.isEmpty)
//                .padding(.vertical)
//            }
//            
//            if isLoading {
//                ProgressView("검색 중...")
//            } else if let errorMessage = errorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//            } else {
//                List(searchResults, id: \.placeID) { result in
//                    Button {
//                        Task {
//                            await selectAddress(result)
//                        }
//                    } label: {
//                        Text(result.description)
//                    }
//                }
//                .listStyle(PlainListStyle())
//            }
//            
//            Spacer()
//            
//            Button {
//                saveFavoriteAddress()
//                isNextButtonActive = true
//            } label: {
//                RoundedRectangle(cornerRadius: 15)
//                    .foregroundStyle(.primary)
//                    .frame(width: 300, height: 50)
//                    .overlay(
//                        Text("다음")
//                            .foregroundStyle(Color.white)
//                    )
//            }
//            .disabled(selectedCoordinates == nil)
//        }
//        .padding()
//        .navigationDestination(isPresented: $isNextButtonActive) {
//            TestRoomAddressEnterView()
//        }
//    }
//    
//    // MARK: - Methods
//    
//    private func fetchSearchResults(for query: String) async {
//        isLoading = true
//        errorMessage = nil
//        
//        do {
//            let results = try await AddressSearchManager.shared.fetchAutocompleteResults(for: query)
//            await MainActor.run {
//                searchResults = results
//                isLoading = false
//            }
//        } catch {
//            await MainActor.run {
//                errorMessage = "검색 실패: \(error.localizedDescription)"
//                isLoading = false
//            }
//        }
//    }
//    
//    private func selectAddress(_ result: (description: String, placeID: String)) async {
//        isLoading = true
//        errorMessage = nil
//        
//        do {
//            let coordinates = try await AddressSearchManager.shared.fetchCoordinates(for: result.placeID)
//            await MainActor.run {
//                selectedCoordinates = coordinates
//                searchText = result.description
//                isLoading = false
//            }
//        } catch {
//            await MainActor.run {
//                errorMessage = "위치 정보를 가져올 수 없습니다."
//                isLoading = false
//            }
//        }
//    }
//    
//    private func saveFavoriteAddress() {
//        guard let coordinates = selectedCoordinates else { return }
//        
//        do {
//            let newFavoriteAddress = TestFavoriteAddress(
//                latitude: coordinates.latitude,
//                longitude: coordinates.longitude
//            )
//            modelContext.insert(newFavoriteAddress)
//            try modelContext.save()
//        } catch {
//            print("Failed to save favorite address: \(error.localizedDescription)")
//        }
//    }
//}
//
////#Preview {
////    TestFavAdressEnterView()
////}
