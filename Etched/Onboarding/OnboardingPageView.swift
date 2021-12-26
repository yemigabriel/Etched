//
//  OnboardingPageView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI

struct OnboardingPageView: View {
    var index = 1
    
    var body: some View {
        VStack {
            Image(Page.pages[index].imageName)
                .resizable()
                .frame(maxWidth: .infinity)
                .scaledToFit()
            
            Text(Page.pages[index].description)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView()
    }
}
