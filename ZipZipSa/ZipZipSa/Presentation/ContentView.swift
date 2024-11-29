//
//  ContentView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    @State var isLoading: Bool = true
    
    var body: some View {
        if isLoading {
            LaunchScreen()
                .onAppear {
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
