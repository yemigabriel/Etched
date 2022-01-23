//
//  JournalCardView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/27/21.
//

import SwiftUI


struct JournalCardView: View {
    @ObservedObject var journal: JournalMO
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(journal.wrappedTimestamp.formattedShortDate())
                .font(.headline)
                .kerning(2.5)
            
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .trailing) {
                    HStack{
                        Text("\(journal.wrappedContent)")
                            .foregroundColor(Color.primary)//(UIColor.primary).opacity(0.7))
                            .kerning(2.5)
                            .lineLimit(4)
                            .frame(minHeight: 50)
                        
                        Spacer(minLength: journal.wrappedImages.count > 0 ? 50 : 0)
                    }
                    
                    HStack {
                        if let mood = journal.wrappedMood {
                            Text(mood.emoji)
                        }
                        
                        Spacer(minLength: 100)
                        
                        if let location = journal.location {
                            Image(systemName: "mappin.and.ellipse")
                            Text(location.wrappedName)
                                .font(.footnote)
                                .kerning(2.5)
                                .textCase(.uppercase)
                                .lineLimit(2)
                        }
                    }
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                }
                
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.purple.opacity(0.2), radius: 10, x: 5, y: 5)
                
                
                if (journal.images?.count ?? 0) > 0 {
                    if let image = UIImage(contentsOfFile: journal.wrappedSavedImages[0]) {
                        Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .offset(x: 20, y: -20)
                    }
                }
                
            }
        }
        .onAppear(perform: {
            print(journal.wrappedContent, journal.images)
        })
        .padding(.vertical)
        
    }
}

//struct JournalCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        JournalCardView(journal: Journal.sampleJournals[0])
//    }
//}
