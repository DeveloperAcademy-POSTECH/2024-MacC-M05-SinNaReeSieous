//
//  ContentView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    @State var isLoading: Bool = true
    @Query var users: [User]
    
    var body: some View {
        if isLoading {
            LaunchScreen()
                .onAppear {
                    if users.isEmpty {
                        firstLaunch = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
        } else {
            if firstLaunch {
                OnboardingView()
            } else {
                MainView()
            }
        }
    }
}

#Preview {
    ContentView()
}
