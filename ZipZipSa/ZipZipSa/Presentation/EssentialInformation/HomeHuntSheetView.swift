//
//  HomeHuntSheetView.swift
//  ZipZipSa
//

import SwiftUI

/// 집 보러가기 플로우의 진입 시트.
/// 새로 기록할 HomeData와 NavigationStack을 소유하고 기본정보 화면(.homeHunt)을 루트로 띄운다.
struct HomeHuntSheetView: View {
    @Binding var showHomeHuntSheet: Bool

    @State private var homeData = HomeData()

    var body: some View {
        NavigationStack {
            EssentialInfoView(
                mode: .homeHunt,
                homeData: $homeData,
                showHomeHuntSheet: $showHomeHuntSheet
            )
        }
    }
}
