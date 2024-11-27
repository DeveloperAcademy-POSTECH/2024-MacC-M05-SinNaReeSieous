//
//  HomeListView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/27/24.
//

import SwiftUI

import SwiftUI

struct HomeListView: View {
    var body: some View {
        ZStack{
            Color.Background.primary
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("내가 본 집")
                    .applyZZSFont(zzsFontSet: .largeTitle)
                
                Image("cryingYongboogiSquareColor")
                
                Text("아직 내가 둘러본 집이 없어요.\n집을 보러 가서 집을 추가해 보세요.")
                
                
                
            }
        }
    }
}

#Preview {
    HomeListView()
}
