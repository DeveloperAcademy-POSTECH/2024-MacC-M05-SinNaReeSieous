//
//  PlaceDetailView.swift
//  Eggong
//
//  Created by 조우현 on 10/17/24.
//

import SwiftUI

struct PlaceDetailView: View {
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            headerView
            descriptionView
            storyImageView
            storyView
            footerView
        }
    }
}

private extension PlaceDetailView {
    // MARK: - View
    
    var headerView: some View {
        PlaceDetailHeaderView()
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
