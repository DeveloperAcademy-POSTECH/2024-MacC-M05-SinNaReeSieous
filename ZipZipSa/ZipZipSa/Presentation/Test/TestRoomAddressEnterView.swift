////
////  TestRoomAddressEnterView.swift
////  ZipZipSa
////
////  Created by 조우현 on 11/25/24.
////
//
//import SwiftUI
//import CoreLocation
//
//struct TestRoomAddressEnterView: View {
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var locationManager = LocationManager()
//    
//    @State private var searchText: String = ""
//    @State private var searchResults: [(description: String, placeID: String)] = []
//    @State private var selectedCoordinates: CLLocationCoordinate2D?
//    @State private var isLoading = false
//    @State private var errorMessage: String?
//    
//    var body: some View {
//        VStack {
//            SearchBar
//            CurrentLocationButton
//                
//            if isLoading {
//                ProgressView("검색 중...")
//            } else if let errorMessage = errorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//            } else {
//                SearchResults
//            }
//            
//            Spacer()
//            DoneButton
//        }
//        .padding()
//    }
//}
//
//extension TestRoomAddressEnterView {
//    // MARK: - View
//    
//    var SearchBar: some View {
//        HStack {
//            TextField("집 주소를 입력하세요", text: $searchText)
//                .padding()
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .autocapitalization(.none)
//                .disableAutocorrection(true)
//            
//            Button {
//                Task {
//                    await fetchSearchResults(for: searchText)
//                }
//            } label: {
//                Text("검색")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .disabled(searchText.isEmpty)
//            .padding(.vertical)
//        }
//    }
//    
//    var CurrentLocationButton: some View {
//        Button {
//            fetchCurrentLocation()
//        } label: {
//            Text("현재위치로 저장하기")
//                .underline()
//                .foregroundStyle(.gray)
//                .font(Font.system(size: 16))
//        }
//    }
//    
//    var SearchResults: some View {
//        List(searchResults, id: \.placeID) { result in
//            Button {
//                Task {
//                    await selectAddress(result)
//                }
//            } label: {
//                Text(result.description)
//            }
//        }
//        .listStyle(PlainListStyle())
//    }
//    
//    var DoneButton: some View {
//        Button {
//            // TODO: Room모델에 집 주소 저장
//            dismiss()
//        } label: {
//            RoundedRectangle(cornerRadius: 15)
//                .foregroundStyle(.primary)
//                .frame(width: 300, height: 50)
//                .overlay(
//                    Text("완료")
//                        .foregroundStyle(Color.white)
//                )
//        }
//        .disabled(selectedCoordinates == nil)
//    }
//    
//    // MARK: - Action
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
//    private func fetchCurrentLocation() {
//        locationManager.requestLocationAuthorization()
//        if let location = locationManager.userLocation {
//            selectedCoordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//            reverseGeocode()
//        } else {
//            errorMessage = "현재 위치를 가져올 수 없습니다."
//        }
//    }
//    
//    private func reverseGeocode() {
//        guard let coordinates = selectedCoordinates else {
//            errorMessage = "좌표가 선택되지 않았습니다."
//            return
//        }
//        
//        isLoading = true
//        errorMessage = nil
//        
//        Task {
//            do {
//                let address = try await AddressSearchManager.shared.getAddressForLatLng(
//                    latitude: coordinates.latitude,
//                    longitude: coordinates.longitude
//                )
//                await MainActor.run {
//                    searchText = address
//                    isLoading = false
//                }
//            } catch {
//                await MainActor.run {
//                    errorMessage = "주소 변환 실패: \(error.localizedDescription)"
//                    isLoading = false
//                }
//                print("Error occurred: \(error)")
//            }
//        }
//    }
//}
//
//#Preview {
//    TestRoomAddressEnterView()
//}
