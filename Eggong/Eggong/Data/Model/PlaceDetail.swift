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
        id: "ANSi11G77ESskX7d4s2S",
        name: "카페 낙원",
        keywords: ["따뜻한", "강아지", "철길숲"],
        imageURLString: "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/Places%2FANSi11G77ESskX7d4s2S%2F20F1EC9C-DEAA-4EE2-890A-805FB199EDF0.jpeg?alt=media&token=f33663f7-b078-4347-88a3-3e32a3225873",
        makingStory: "저는 우리 카페를 자연 속에서 쉼을 찾을 수 있는 특별한 공간으로 운영하고 있습니다. 포항의 맑은 공기와 햇살이 가득한 곳에서, 사람과 반려동물이 함께 머물며 마음을 놓을 수 있는 공간이죠. 우리 카페는 강아지들도, 또 다른 반려동물들도 함께할 수 있는 곳이라 더 따뜻한 분위기가 흐르는 것 같아요. 어느 손님이라도 편하게 머무실 수 있도록 세심하게 신경을 씁니다.",
        storyImageURLStrings: [
            "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/PlaceDetails%2FANSi11G77ESskX7d4s2S%2FABD9E159-BCEB-429A-8438-FD0F1B1DAB7B.jpeg?alt=media&token=9e3d6263-042f-47c9-878f-c37ea4819482",
            "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/PlaceDetails%2FANSi11G77ESskX7d4s2S%2FB463536B-398C-48E2-8B22-6EA237E181AC.jpeg?alt=media&token=29ffe9b3-fc41-41b1-b594-4c820905a785",
            "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/PlaceDetails%2FANSi11G77ESskX7d4s2S%2FA0FD9C53-C66E-4A01-A6EA-DA295C228F28.jpeg?alt=media&token=4b13be9b-f23a-4911-a74f-e622c5aaad42"],
        stories: [
            "저는 LP를 모으는 취미가 있는데, 특히 팝 음악을 좋아해요. 그 아날로그 소리가 주는 따뜻함이 참 좋아서, 카페에서도 자주 틀어요. 남편과의 추억도 많고, 손님들이 그 감성을 느끼실 때마다 흐뭇해요. 음악을 통해 손님들과 작은 행복을 나누는 것도 카페를 운영하는 즐거움 중 하나죠.",
            "저희 카페를 시작할 때, 남편과 함께 담벼락에 모두의 행운을 비는 문구를 적고, 제가 좋아하는 무지개와 ‘카페 낙원’이라는 이름을 낙서로 새겼어요. 이곳이 손님들에게 따뜻한 기억이 남는 공간이 되었으면 하는 바람을 담았죠. 그 벽은 우리 부부의 마음이 담긴 특별한 장소예요.",
            "저희 강아지, 탄이는 저희에게 많이 특별한 존재예요. 그래서 강아지의 모습을 스티커나 달력으로 만들어서 손님들과 그 애정을 나누고 있죠. 처음엔 장난처럼 시작했지만, 손님들이 너무 좋아해 주셔서 지금은 카페의 작은 시그니처가 되었어요. 귀여운 스티커나 달력을 받아가시는 손님들을 보면 정말 기분이 좋아요."
        ]
    )
}
