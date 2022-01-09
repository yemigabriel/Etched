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
                            Text(mood.emoji ?? "")
                        }
                        Spacer()
                        if let location = journal.wrappedLocation {
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
                .background(Color(UIColor.systemGroupedBackground))
                .cornerRadius(10)
                .shadow(color: Color.purple.opacity(0.2), radius: 10, x: 5, y: 5)
                
                
                if (journal.images?.count ?? 0) > 0 {
//                    Image(uiImage: UIImage(contentsOfFile: FileManager.default.getSavedImagesFolder().appendingPathComponent(journal.wrappedImages[0]).path) ?? "")
//                    let imageUrl = FileManager.default.getSavedImagesFolder().appendingPathComponent(journal.wrappedImages[0])
                    Image(uiImage: UIImage(contentsOfFile: journal.wrappedSavedImages[0])! )
//                    AsyncImage(url: FileManager.default.getSavedImagesFolder().appendingPathComponent(journal.wrappedImages[0])) { image in
//                        image
//                            .resizable()
//                            .scaledToFill()
//                    } placeholder: {
//                        ProgressView()
//                    }
//                    .frame(width: 75, height: 75)
//                    .background(Color.purple)
//                    .cornerRadius(10)
//                    .offset(x: 20, y: -20)

                    
//                    Image(journal.wrappedImages[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .offset(x: 20, y: -20)
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