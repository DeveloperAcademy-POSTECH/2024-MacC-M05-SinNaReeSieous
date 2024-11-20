//
//  ContentView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var hasRoomModel: Bool = false
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: RoomScanView(hasRoomModel: $hasRoomModel)) {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("RoomScanView로 이동")
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
