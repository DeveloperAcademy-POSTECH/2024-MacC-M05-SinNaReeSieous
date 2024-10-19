//
//  PlaceDetailView.swift
//  Eggong
//
//  Created by 조우현 on 10/17/24.
//

import SwiftUI

struct PlaceDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK: Body
    
    var body: some View {
        VStack {
            headerView
            descriptionView
            storyImageView
            storyView
            footerView
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
                    Image(systemName: "light.beacon.min")
                }
            }
        }
        .gesture(DragGesture().onEnded { gesture in
            if gesture.translation.width > 100 {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
    }
}

private extension PlaceDetailView {
    // MARK: View
    
    var headerView: some View {
        VStack {
            PlaceDetailHeaderView()
            Spacer()
        }
    }
    
    var descriptionView: some View {
        PlaceDetailDescriptionView()
    }
    
    var storyImageView: some View {
        PlaceDetailStoryImageView()
    }
    
    var storyView: some View {
        PlaceDetailStoryView()
    }
    
    var footerView: some View {
        PlaceDetailFooterView()
    }
}

// MARK: - Preview
#Preview {
    PlaceDetailView()
}
