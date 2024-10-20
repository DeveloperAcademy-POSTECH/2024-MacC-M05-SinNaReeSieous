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
    @Binding var placeID: String?
    @State private var selectedIndex: Int = 0
    @State private var scrollOffset: CGFloat = 0
    
    let placeDetailService: PlaceDetailService = DefaultPlaceDetailService()
    let userService: UserService = DefaultUserService()
    
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
                    // TODO: Bookmark
                } label: {
                    Image(systemName: "bookmark")
                        .foregroundStyle(.white)
                }
            }
        }
        // 원래 제스처를 선호해서요 !! 일단 원래 제스처를 사용할 수 있게 바꿨어요
//        .gesture(DragGesture().onEnded { gesture in
//            if gesture.translation.width > 100 {
//                self.presentationMode.wrappedValue.dismiss()
//            }
//        })
        .task {
            do {
                self.placeDetail = try await placeDetailService.getPlaceDetail(id: placeID)
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
                .placeholder {
                    Image(.placeHolder)
                }
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
                    .font(.pretendard(size: 46, weight: .bold))
                    .foregroundStyle(.white)
                
                Text(keywordText)
                    .font(.pretendard(size: 13, weight: .medium))
                    .foregroundStyle(.white)
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
            .font(.pretendard(size: 28, weight: .extraBold))
            
            Text(placeDetail.makingStory)
                .font(.pretendard(size: 16, weight: .medium))
                .padding(.top, 8)
        }
        .padding(.horizontal, 16)
    }
    
    var storyImageView: some View {
        VStack(alignment: .leading) {
            Text("이야기 보기")
                .font(.pretendard(size: 28, weight: .extraBold))
                .padding(.horizontal, 16)
            
            GeometryReader { geometry in
                TabView(selection: $selectedIndex) {
                    KFImage(URL(string: placeDetail.storyImageURLStrings[0]))
                        .placeholder {
                            Image(.placeHolder)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .tag(0)
                    KFImage(URL(string: placeDetail.storyImageURLStrings[1]))
                        .placeholder {
                            Image(.placeHolder)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .tag(1)
                    KFImage(URL(string: placeDetail.storyImageURLStrings[2]))
                        .placeholder {
                            Image(.placeHolder)
                        }
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
                    .font(.pretendard(size: 15, weight: .regular))
            } else if selectedIndex == 1 {
                Text(placeDetail.stories[1])
                    .font(.pretendard(size: 15, weight: .regular))
            } else if selectedIndex == 2 {
                Text(placeDetail.stories[2])
                    .font(.pretendard(size: 15, weight: .regular))
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: selectedIndex)
        .padding(.horizontal, 16)
    }
    
    var footerView: some View {
        VStack(alignment: .leading) {
            Text("더 자세한 정보")
                .font(.pretendard(size: 28, weight: .extraBold))
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
    PlaceDetailView(placeID: .constant(Place.dummy1.id))
}
