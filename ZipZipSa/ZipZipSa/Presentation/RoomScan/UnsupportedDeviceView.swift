//
//  UnsupportedDeviceView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/27/24.
//

import SwiftUI

struct UnsupportedDeviceView: View {
    @State var showResultCard: Bool = false
    @Binding var model: UIImage?
    @Binding var homeData: HomeData
    @Binding var showHomeHuntSheet: Bool
    
    var body: some View {
        ZStack {
            BackgroundView
            VStack(spacing: 0) {
                Spacer()
                CharacterImage
                UnsupportedTitle
                UnsupportedDescription
                Spacer()
                ShowResultCardButton
            }
        }
        .fullScreenCover(isPresented: $showResultCard) {
            ResultCardView(model: $model, homeData: $homeData, showHomeHuntSheet: $showHomeHuntSheet)
        }
    }
}

private extension UnsupportedDeviceView {
    // MARK: - View
    
    var BackgroundView: some View {
        Image(.imgUnsupportedDevice)
            .resizable()
            .frame(width: UIScreen.screenSize.width, height: UIScreen.screenSize.height)
            .scaledToFill()
            .blur(radius: 6, opaque: true)
            .overlay {
                Rectangle()
                    .fill(Color.black.opacity(0.4))
            }
            .ignoresSafeArea()
    }
    
    var CharacterImage: some View {
        Image(.charUnsupportedDevice)
            .resizable()
            .scaledToFit()
            .frame(width: 95, height: 86)
            .padding(.bottom, 20)
    }
    
    var UnsupportedTitle: some View {
        Text(ZipLiteral.UnsupportedDevice.title)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.Text.onColorPrimary)
            .applyZZSFont(zzsFontSet: .title1)
            .padding(.bottom, 27)
    }
    
    var UnsupportedDescription: some View {
        Text(ZipLiteral.UnsupportedDevice.description)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.Text.onColorPrimary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
    }
    
    var ShowResultCardButton: some View {
        Button {
            showResultCard = true
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.Button.primaryBlue)
                .frame(height: 53)
                .overlay(
                    Text(ZipLiteral.UnsupportedDevice.showResult)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyBold)
                )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 45)
    }
}
