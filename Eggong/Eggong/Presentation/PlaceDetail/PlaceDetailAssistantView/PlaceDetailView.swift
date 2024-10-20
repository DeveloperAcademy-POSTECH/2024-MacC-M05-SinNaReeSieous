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
            Image(.sampleThumbnail)
                .resizable()
                .scaledToFill()
                .frame(height: max(340 + scrollOffset, 340))
                .clipped()
                .overlay {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                }
            
            VStack(alignment: .leading) {
                Text("카페 휙")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                HStack(spacing: 20) {
                    Text("따뜻한")
                    Text("자유로운")
                    Text("풋풋한")
                }
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
            
            Text("저는 이 카페가 사람들이 와서 편하게 수다 떨고, 웃고, 함께 시간을 보낼 수 있는 공간이었으면 좋겠어요. 커피나 음료는 물론 중요하지만, 이곳은 대화하고 어울리는 게 더 큰 의미라고 생각하거든요. 혼자 조용히 책을 읽는 그런 카페가 아니라, 친구들끼리 모여서 시끌벅적하게 이야기 나누고, 웃음소리로 가득 찬 그런 분위기를 만들고 싶어요.")
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
                    Image(.smapleImage1)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .tag(0)
                    Image(.smapleImage2)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .tag(1)
                    Image(.smapleImage3)
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
                Text("지난달에는 고려대 학생들과 협업해 아침밥 사업을 기획하고 진행했어요. 등교하는 학생들, 출근하는 직원들, 그리고 고생한다며 따뜻한 인사를 건네주시는 어르신들 덕분에 마음이 참 따뜻해졌답니다. 여섯 시부터 출근하느라 피곤했지만, 그만큼 보람도 크게 느꼈어요.")
            } else if selectedIndex == 1 {
                Text("리브랜딩을 위해 새벽까지 이어지는 메뉴 개발 현장입니다. 휙의 시그니처 메뉴들은 긴 시간에 걸쳐 내부 회의와 수많은 시음을 거쳐 손님들께 선보이게 됩니다. 한층 더 완성도 높은 메뉴를 위해 팀원들은 끊임없는 논의와 테스트를 반복하며 최선을 다하고 있습니다.")
            } else if selectedIndex == 2 {
                Text("최근에는 시립대 관현악 동아리와 협업해 특별한 클래식 공연을 열었습니다. 이번엔시립대 학생들뿐만 아니라 동네 주민분들도 함께 찾아주셔서 모두가 한데 어우러져 클래식의 매력을 만끽한 멋진 경험이었어요. 지역 사회와 더 가까워질 수 있는 뜻깊은 시간이었습니다.")
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
}

// MARK: - Preview
#Preview {
    PlaceDetailView()
}
