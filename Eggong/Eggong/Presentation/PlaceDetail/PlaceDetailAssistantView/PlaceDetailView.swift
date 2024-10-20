//
//  PlaceDetailView.swift
//  Eggong
//
//  Created by 조우현 on 10/17/24.
//

import SwiftUI
import Kingfisher

struct PlaceDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var placeDetail = PlaceDetail.dummy
    @State private var selectedIndex: Int = 0
    @State private var scrollOffset: CGFloat = 0
    
    let placeDetailService: PlaceDetailService = DefaultPlaceDetailService()
    
    // MARK: Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                headerView
                descriptionView
                storyImageView
                storyView
                footerView
            }
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            scrollOffset = geo.frame(in: .global).minY
                        }
                        .onChange(of: geo.frame(in: .global).minY) { _, newValue in
                            scrollOffset = newValue
                        }
                }
            )
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationBackButton {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: 신고하기 View로 이동
                } label: {
                    Image(systemName: "light.beacon.min.fill")
                        .foregroundStyle(.white)
                }
            }
        }
        .gesture(DragGesture().onEnded { gesture in
            if gesture.translation.width > 100 {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .task {
            do {
                // TODO: getPlaceDetail id 처리
                self.placeDetail = try await placeDetailService.getPlaceDetail(id: placeDetail.id) ?? PlaceDetail.dummy
            } catch {
                print(error)
            }
        }
    }
}

private extension PlaceDetailView {
    // MARK: View
    
    var headerView: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(URL(string: placeDetail.imageURLString))
                .resizable()
                .scaledToFill()
                .frame(height: max(340 + scrollOffset, 340))
                .clipped()
                .overlay {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                }
            
            VStack(alignment: .leading) {
                Text(placeDetail.name)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                Text(keywordText)
                    .foregroundStyle(.white)
                    .font(.caption)
            }
            .padding(16)
        }
        .frame(height: 340 + (scrollOffset > 0 ? scrollOffset : 0))
        .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading) {
            Group {
                Text("카페를 어떤 공간으로")
                Text("만들고 싶으셨나요?")
            }
            .font(.title2.bold())
            
            Text(placeDetail.makingStory)
                .padding(.top, 8)
        }
        .padding(.horizontal, 16)
    }
    
    var storyImageView: some View {
        VStack(alignment: .leading) {
            Text("이야기 보기")
                .padding(.horizontal, 16)
                .font(.title2.bold())
            
            GeometryReader { geometry in
                TabView(selection: $selectedIndex) {
                    KFImage(URL(string: placeDetail.storyImageURLStrings[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .tag(0)
                    KFImage(URL(string: placeDetail.storyImageURLStrings[1]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .tag(1)
                    KFImage(URL(string: placeDetail.storyImageURLStrings[2]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            .frame(height: 480)
        }
    }
    
    var storyView: some View {
        ZStack {
            if selectedIndex == 0 {
                Text(placeDetail.stories[0])
            } else if selectedIndex == 1 {
                Text(placeDetail.stories[1])
            } else if selectedIndex == 2 {
                Text(placeDetail.stories[2])
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: selectedIndex)
        .padding(.horizontal, 16)
    }
    
    var footerView: some View {
        VStack(alignment: .leading) {
            Text("더 자세한 정보")
                .font(.title2.bold())
                .padding(.bottom, 10)
            
            HStack {
                Text("네이버지도")
                    .font(.caption.bold())
                
                Spacer()
                
                Button {
                    // TODO: 네이버지도로 이동
                } label: {
                    Text("바로가기").underline()
                        .foregroundStyle(.gray)
                        .font(.caption.bold())
                }
            }
            
            HStack {
                Text("카카오맵")
                    .font(.caption.bold())
                
                Spacer()
                
                Button {
                    // TODO: 카카오맵으로 이동
                } label: {
                    Text("바로가기").underline()
                        .foregroundStyle(.gray)
                        .font(.caption.bold())
                }
            }
            
            // TODO: 방문 여부에 따라 state 값 변경
            ActionButton(state: .enabled, tapAction: {})
                .padding(.top, 40)
                .padding(.bottom, 30)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: Computed Values
    
    var keywordText: String {
        let sortedKeywords = placeDetail.keywords.sorted(by: {$0.count < $1.count})
        return sortedKeywords.joined(separator: "\t")
    }
}

// MARK: - Preview
#Preview {
    PlaceDetailView()
}
