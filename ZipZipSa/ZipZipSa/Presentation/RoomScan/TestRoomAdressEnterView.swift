//
//  TestEnterAddressView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/25/24.
//

import SwiftUI
import SwiftData
import CoreLocation

struct TestRoomAdressEnterView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var locationManager = LocationManager()
    
    @State private var mainPicture: UIImage?
    @State private var searchText: String = ""
    @State private var searchResults: [(description: String, placeID: String)] = []
    @State private var selectedCoordinates: CLLocationCoordinate2D?
    @State private var isNextButtonActive = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showRoomScanView: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("집 주소를 입력하세요", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button {
                    Task {
                        await fetchSearchResults(for: searchText)
                    }
                } label: {
                    Text("검색")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(searchText.isEmpty)
                .padding(.vertical)
            }
            
            Button {
                // TODO: 불러온 현재위치(위도경도)를 한글주소로 바꿔서 TextField에 띄우기
                fetchCurrentLocation()
            } label: {
                Text("현재위치로 저장하기")
                    .underline()
                    .foregroundStyle(.gray)
                    .font(Font.system(size: 16))
            }
            
            if isLoading {
                ProgressView("검색 중...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                List(searchResults, id: \.placeID) { result in
                    Button {
                        Task {
                            await selectAddress(result)
                        }
                    } label: {
                        Text(result.description)
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
            
            Button {
                Task {
                    await saveRoomAddress()
                }
                showRoomScanView.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.primary)
                    .frame(width: 300, height: 50)
                    .overlay(
                        Text("스캔하기")
                            .foregroundStyle(Color.white)
                    )
            }
        }
        .navigationDestination(isPresented: $showRoomScanView) {
            if let selectedCoordinates {
                RoomScanView(
                    latitude: selectedCoordinates.latitude,
                    longitude: selectedCoordinates.longitude
                )
            }
        }
        .padding()
    }
    
    // MARK: - Methods
    
    private func fetchSearchResults(for query: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await AddressSearchManager.shared.fetchAutocompleteResults(for: query)
            await MainActor.run {
                searchResults = results
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "검색 실패: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    private func selectAddress(_ result: (description: String, placeID: String)) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let coordinates = try await AddressSearchManager.shared.fetchCoordinates(for: result.placeID)
            await MainActor.run {
                selectedCoordinates = coordinates
                searchText = result.description
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "위치 정보를 가져올 수 없습니다."
                isLoading = false
            }
        }
    }
    
    private func fetchCurrentLocation() {
        locationManager.requestLocationAuthorization()
        if let location = locationManager.userLocation {
            selectedCoordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            // TODO: 역지오코딩으로 좌표 -> 주소로 변경해서 넣어야 함
            searchText = "현재 위치"
        } else {
            errorMessage = "현재 위치를 가져올 수 없습니다."
        }
    }
    
    //SwiftData에 공간 정보를 저장하는 함수
    private func saveRoomAddress() async {
        guard let coordinates = selectedCoordinates else {
            errorMessage = "좌표가 선택되지 않았습니다."
            return
        }
        do {
            let facilities = try await FacilityChecker.shared.checkFacilities(
                at: coordinates,
                for: Facility.allCases.map { $0.rawValue }
            )
            print("checkFacilities의 결과: \(facilities)")
            
            let availableFacilities = Facility.allCases.filter { facilities[$0.rawValue] == true }
            print("availableFacilities: \(availableFacilities)")
            
            let newRoom = SampleRoom(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                availableFacilities: availableFacilities
            )
            
            modelContext.insert(newRoom)
            try modelContext.save()
            print("주소가 성공적으로 저장되었습니다: \(coordinates.latitude), \(coordinates.longitude)")
        } catch {
            print("저장 실패: \(error)")
        }
    }
}

#Preview {
    TestRoomAdressEnterView()
}
