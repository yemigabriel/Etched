//
//  OnboardingView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Page.pages[currentPage].background
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                ForEach(Page.pages.indices, id: \.self) { index in
                    OnboardingPageView(index: index)
                        .tag(index)
                        .animation(.easeInOut, value: currentPage)
                        .transition(.slide)
                }            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            Button {
                if currentPage == Page.pages.count - 1 {
//                    viewRouter.currentView = .main
                    viewRouter.isNewUser = false
                    return
                }
                currentPage += 1
                
            } label: {
                if currentPage == Page.pages.count - 1 {
                    Text("Get Started")
                        .onboardingButtonStyle(shape: Capsule())
                } else {
                    Image(systemName: "chevron.forward")
                        .onboardingButtonStyle(shape: Circle())
                }
            }
            .padding()
        }
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

struct OnboardingButtonStyle<T: Shape>: ViewModifier {
    let shape: T
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.purple)
            .padding()
            .background(Color.white)
            .clipShape(shape)
    }
}

