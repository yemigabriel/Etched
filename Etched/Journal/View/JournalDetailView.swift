//
//  JournalDetailView.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/9/22.
//

import SwiftUI

struct JournalDetailView: View {
    
//    let journal: JournalMO
    @ObservedObject var viewModel: DetailViewModel
    @State private var image: Image?
    @State private var showingEditView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                image?
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                
                
                Text(viewModel.journal.wrappedContent)
                    .font(.title3)
                    .kerning(1.5)
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
            }
//            .frame(maxWidth: .infinity)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .navigationBarTitle(viewModel.journal.wrappedTimestamp.formattedShortDate())
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showingEditView = true
                } label: {
                    Label("Edit", systemImage: "square.and.pencil")
                        .font(.headline.bold())
                }
            }
        }
        .sheet(isPresented: $showingEditView, onDismiss: {
            print("dismissed... here in detail view")
        }, content: {
            AddJournalView(viewModel: AddEditJournalViewModel(), selectedJournal: viewModel.journal)
        })
        .onAppear {
            if let journalImage = UIImage.loadFirst(from: viewModel.journal.wrappedSavedImages) {
                image = Image(uiImage: journalImage)
            }
        }
    }
}

//struct JournalDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        JournalDetailView(journal: JournalMO(context: PersistenceController.preview.container.viewContext))
//    }
//}
