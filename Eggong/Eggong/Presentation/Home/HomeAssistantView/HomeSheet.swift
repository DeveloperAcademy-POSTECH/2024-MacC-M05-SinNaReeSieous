//
//  HomeSheet.swift
//  Eggong
//
//  Created by JIN LEE on 10/21/24.
//

import SwiftUI

enum SheetType: Identifiable {
    case bookmark, myPage
    var id: Self { self }
}

struct SheetView: View {
    let type: SheetType
    @Binding var showSheet: SheetType?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("This is the \(type == .bookmark ? "Bookmark" : "My Page") sheet content!")
                    .padding()
                Button("Dismiss") {
                    showSheet = nil
                }
                .padding()
            }
            .navigationTitle(type == .bookmark ? "Bookmark" : "My Page")
            .navigationBarItems(trailing: Button("Close") {
                showSheet = nil
            })
        }
    }
}
