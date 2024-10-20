//
//  PlaceDetail.swift
//  Eggong
//
//  Created by YunhakLee on 10/18/24.
//

import Foundation

struct PlaceDetail: FirebaseCodable, Identifiable {
    var id: String?
    var name: String
    var keywords: [String]
    var imageURLString: String
    var makingStory: String
    var storyImageURLStrings: [String]
    var stories: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case keywords
        case imageURLString
        case makingStory
        case storyImageURLStrings
        case stories
    }
}


extension PlaceDetail {
    static let dummy = PlaceDetail(
        name: "카페 휙",
        keywords: ["따뜻한", "자유로운", "풋풋한"],
        imageURLString: "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/Places%2FLQXiQ1h77EJsmX7daDpG%2F0C3A8BDF-FD28-41BD-BA23-390A2171A1AD.jpeg?alt=media&token=ae61edda-71ee-4714-a0f8-1c000382f70e",
        makingStory: "저는 이 카페가 사람들이 와서 편하게 수다 떨고, 웃고, 함께 시간을 보낼 수 있는 공간이었으면 좋겠어요. 커피나 음료는 물론 중요하지만, 이곳은 대화하고 어울리는 게 더 큰 의미라고 생각하거든요. 혼자 조용히 책을 읽는 그런 카페가 아니라, 친구들끼리 모여서 시끌벅적하게 이야기 나누고, 웃음소리로 가득 찬 그런 분위기를 만들고 싶어요.",
        storyImageURLStrings: [
            "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/PlaceDetail%2FiPpxjigqHmnrlvHe4Kis%2FSmaple_Image1.jpeg?alt=media&token=7e2e4f85-4321-4bdb-9cca-fd7de12765fd",
            "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/PlaceDetail%2FiPpxjigqHmnrlvHe4Kis%2FSmaple_Image2.jpeg?alt=media&token=7e5ceee4-c6de-4d7a-b86d-627094a4ba30",
            "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/PlaceDetail%2FiPpxjigqHmnrlvHe4Kis%2FSmaple_Image3.jpeg?alt=media&token=82d90eaa-f080-40d0-a69c-c9aaa5f6b6e3"],
        stories: [
            "지난달에는 고려대 학생들과 협업해 아침밥 사업을 기획하고 진행했어요. 등교하는 학생들, 출근하는 직원들, 그리고 고생한다며 따뜻한 인사를 건네주시는 어르신들 덕분에 마음이 참 따뜻해졌답니다. 여섯 시부터 출근하느라 피곤했지만, 그만큼 보람도 크게 느꼈어요.",
            "리브랜딩을 위해 새벽까지 이어지는 메뉴 개발 현장입니다. 휙의 시그니처 메뉴들은 긴 시간에 걸쳐 내부 회의와 수많은 시음을 거쳐 손님들께 선보이게 됩니다. 한층 더 완성도 높은 메뉴를 위해 팀원들은 끊임없는 논의와 테스트를 반복하며 최선을 다하고 있습니다.",
            "최근에는 시립대 관현악 동아리와 협업해 특별한 클래식 공연을 열었습니다. 이번엔시립대 학생들뿐만 아니라 동네 주민분들도 함께 찾아주셔서 모두가 한데 어우러져 클래식의 매력을 만끽한 멋진 경험이었어요. 지역 사회와 더 가까워질 수 있는 뜻깊은 시간이었습니다."
        ]
    )
}
