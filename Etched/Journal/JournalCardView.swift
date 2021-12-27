//
//  JournalCardView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/27/21.
//

import SwiftUI


struct JournalCardView: View {
    let journal: Journal
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(journal.formattedDate)
                .font(.headline)
                .kerning(2.5)
            
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .trailing) {
                    HStack{
                        Text("\(journal.content)")
                            .foregroundColor(.black.opacity(0.7))
                            .kerning(2.5)
                            .lineLimit(4)
                            .frame(minHeight: 50)
                        
                        Spacer(minLength: (journal.images?.count ?? 0) > 0 ? 50 : 0)
                    }
                    
                    HStack {
                        if let mood = journal.mood {
                            Text(mood.emoji ?? "")
                        }
                        Spacer()
                        if let location = journal.location {
                            Image(systemName: "mappin.and.ellipse")
                            Text(location.name ?? "")
                                .font(.caption2)
                                .kerning(2.5)
                                .textCase(.uppercase)
                        }
                    }
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                }
                
                .frame(maxWidth: .infinity)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .shadow(color: Color.purple.opacity(0.2), radius: 10, x: 5, y: 5)
                
                
                if (journal.images?.count ?? 0) > 0 {
                    Image(journal.images![0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .offset(x: 20, y: -20)
                }
                
            }
        }
        .padding(.vertical)
    }
}

struct JournalCardView_Previews: PreviewProvider {
    static var previews: some View {
        JournalCardView(journal: Journal.sampleJournals[0])
    }
}
