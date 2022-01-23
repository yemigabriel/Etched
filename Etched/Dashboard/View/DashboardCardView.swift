//
//  DashboardCardView.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/16/22.
//

import SwiftUI

struct DashboardCardView: View {
    let cardTitile: String
    let cardImage: String
    let cardSize: CGSize
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(cardImage)
                .resizable()
                .scaledToFit()
                .clipped()
                .frame(maxWidth: .infinity)
                .frame(height: cardSize.height)
                .background(.white)
            
            
            HStack {
                Text(cardTitile)
                    .font(.subheadline)
                    .kerning(2.5)
                
                Spacer()
                
                Image(systemName: "chevron.right.circle.fill")
                    .foregroundColor(.purple)
            }
            .padding()
            .background(.purple.opacity(0.3))
        }
        .frame(maxWidth: .infinity)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.purple.opacity(0.3)))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    
    }
}

struct DashboardCardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardCardView(cardTitile: "How you've been feeling ...", cardImage: "dashboard_mood", cardSize: CGSize(width: 300, height: 300))
    }
}
