//
//  PlaceDetailStoryImageView.swift
//  Eggong
//
//  Created by 조우현 on 10/17/24.
//

import SwiftUI

struct PlaceDetailStoryImageView: View {
    @Binding var selectedIndex: Int
    
    var body: some View {
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
}

//#Preview {
//    PlaceDetailStoryImageView()
//}
