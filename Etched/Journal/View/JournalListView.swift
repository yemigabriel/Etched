//
//  JournalListView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI
import Combine

struct JournalListView: View {
    @StateObject var viewModel = JournalListViewModel()
    @Environment(\.dismiss) var dismiss
    var moodEmoji: String?
    @State private var message = "You haven't created any journals yet."
    
    var body: some View {
        Group {
            if viewModel.journals.isEmpty {
                EmptyList(message: message)
//                    .listRowBackground(Color.clear)
            } else {
                ForEach(viewModel.journals, id: \.wrappedId) { journal in
                    JournalCardView(journal: journal)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                if let offset = viewModel.journals.firstIndex(where: {$0 == journal}) {
                                    viewModel.selectedIndex = offset
                                    viewModel.showDeleteAlert = true
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .frame(width: 50, height: 50)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                viewModel.selectedJournal = journal
                                viewModel.showingEditView = true
                            } label: {
                                Label("Edit", systemImage: "square.and.pencil")
                            }
                        }
                        .background(
                            NavigationLink(destination: JournalDetailView(viewModel: DetailViewModel(journal: journal))){}.opacity(0)
                        )
                    
                }
                .onChange(of: viewModel.selectedJournal, perform: { _ in
                    if viewModel.selectedJournal != nil && viewModel.showDetailView == true {
                        //                viewModel.showingEditView = true
                        print("go tot detail: ", viewModel.selectedJournal!.wrappedTimestamp.formattedShortDate())
                        
                    }
                })
                .onAppear(perform: {
                    if let mood = moodEmoji {
                        message = "No journals match this mood"
                        viewModel.getJournals(by: mood)
                    }
                })
                
                .sheet(isPresented: $viewModel.showingEditView, content: {
                    if let selectedJournal = viewModel.selectedJournal {
                        AddJournalView(viewModel: AddEditJournalViewModel(journalPublisher: Just(selectedJournal).eraseToAnyPublisher()))
                        
                    }
                })
                .alert("Are you sure you want to delete this journal?", isPresented: $viewModel.showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        viewModel.delete()
                    }
                }
                
            }
        }
        
    }
    
}

struct EmptyList: View {
    let message: String
    var body: some View {
        VStack {
            Image("emptyData")
                .resizable()
                .frame(width: 75, height: 75)
            Text(message)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView()
    }
}
