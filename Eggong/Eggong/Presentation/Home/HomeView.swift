//
//  HomeView.swift
//  Eggong
//
//  Created by 조우현 on 10/17/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 167)
                HomePlaceListView()
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
}
