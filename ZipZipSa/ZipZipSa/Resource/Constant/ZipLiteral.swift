//
//  ZipLiteral.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import Foundation

enum ZipLiteral {
    enum RoomScan {
        static let doneSacnText: String = "집의 구조가 잘 보이게 3D 모델의 각도를 조절하세요."
        static let cancle: String = "그만두기"
        static let done: String = "완료하기"
        static let reScasn: String = "다시찍기"
        static let save: String = "저장하기"
        static let processing: String = "저장 중..."
    }
    
    enum Checklist {
        static let bottomButton = "집 구조 스캔하기"
        static let navigationTitle = "주인님을 위한\n맞춤 체크리스트예요"
        static let memoSectionTitle = "메모"
        static let memoPlaceHolder = "메모를 입력해 주세요"
    }
}
