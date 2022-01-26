//
//  JournalDetailView.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/9/22.
//

import SwiftUI
import Combine

struct JournalDetailView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    @State private var image: Image?
    @State private var showingEditView = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.screenWidth, height: image == nil ? 0 : 250)
                    .clipped()
                
                if let location = viewModel.journal.location {
                    HStack() {
                        Spacer(minLength: 100)
                        Image(systemName: "mappin.and.ellipse")
                        Text(location.wrappedName)
                            .font(.caption2)
                            .kerning(2.5)
                            .textCase(.uppercase)
                            .lineLimit(2)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    .opacity(0.5)
                }
                Text(viewModel.journal.wrappedContent)
                    .font(.title3)
                    .kerning(1.5)
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
                    .padding()
//                    .background(.clear)
            }
        }
        .frame(maxWidth: .infinity)
        .navigationBarTitle(viewModel.journal.wrappedTimestamp.formattedShortDate())
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if viewModel.journal.mood != nil {
                    Button(viewModel.journal.mood!.emoji!) {}
                }
                Button {
                    showingEditView.toggle()
                } label: {
                    Label("Edit", systemImage: "square.and.pencil")
                        .font(.headline.bold())
                }
                Button {
                    showDeleteAlert = true
                } label: {
                    Label("Delete", systemImage: "trash")
                        .font(.headline.bold())
                }
            }
        }
        .sheet(isPresented: $showingEditView, onDismiss: {
            print("on dismiss")
            if let journalImage = UIImage.loadFirst(from: viewModel.journal.wrappedSavedImages) {
                image = Image(uiImage: journalImage)
            }
        }, content: {
//            AddJournalView(viewModel: AddEditJournalViewModel(), selectedJournal: viewModel.journal)
            AddJournalView(viewModel: AddEditJournalViewModel(journalPublisher: Just(viewModel.journal).eraseToAnyPublisher()))
        })
        .alert("Are you sure you want to delete this journal?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.delete()
                dismiss()
            }
        }
        .onAppear {
            if let journalImage = UIImage.loadFirst(from: viewModel.journal.wrappedSavedImages) {
                image = Image(uiImage: journalImage)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct JournalDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        JournalDetailView(journal: JournalMO(context: PersistenceController.preview.container.viewContext))
//    }
//}
