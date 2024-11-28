//
//  ShareCardView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI

struct ShareCardView: View {
    @Binding var model: UIImage?
    
    var body: some View {
        VStack {
            ShareCardHeaderView()
            
            ChecklistResult
            Seperator
            
            CriticalTags
            Seperator
            
            RoomModel
            Seperator
            
            NearbyFacilities
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.clear, lineWidth: 1)
                .background(Color.Layer.first.clipShape(RoundedRectangle(cornerRadius: 16)))
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 50)
    }
}

private extension ShareCardView {
    // MARK: - View
    
    var ChecklistResult: some View {
        VStack(alignment: .leading) {
            Text("카테고리")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.bottom, 12)
            
            Group {
                Text("TEST TEXT")
                Text("TEST TEXT")
                Text("TEST TEXT")
                Text("TEST TEXT")
                Text("TEST TEXT")
                Text("TEST TEXT")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
    
    var Seperator: some View {
        Rectangle()
            .fill(Color.Additional.seperator)
            .frame(height: 1)
    }
    
    var CriticalTags: some View {
        Group {
            Text("TEST TEXT")
            Text("TEST TEXT")
            Text("TEST TEXT")
        }
    }
    
    var RoomModel: some View {
        VStack {
            if let modelData = model {
                Image(uiImage: modelData)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .scaledToFit()
            } else {
                Text("모델이 없습니다.")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
    }
    
    var NearbyFacilities: some View {
        HStack {
            ForEach(Facility.allCases, id: \.self) { facility in
                Image(systemName: facility.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            
            Spacer()
            
        }
        .padding()
    }
}
