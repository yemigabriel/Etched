//
//  JournalListView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import SwiftUI
import AVFoundation
import Combine

struct JournalListView: View {
    @StateObject var viewModel = JournalListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                //use enumerated to get index as well as the journal
                ForEach(viewModel.journals, id: \.wrappedId) { journal in
                    if journal.id != nil {
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
                                } label: {
                                    Label("Edit", systemImage: "square.and.pencil")
                                }
                                .background(Color.clear)
                            }
                            .background(
                                NavigationLink(destination: JournalDetailView(viewModel: DetailViewModel(journal: journal))){}.opacity(0)
                            )
                    }
                }
            }
            
            .navigationTitle("Home")
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .background(Color(UIColor.systemGray5))
            .onChange(of: viewModel.selectedJournal, perform: { _ in
                if viewModel.selectedJournal != nil {
                    viewModel.showingEditView = true
                }
            })
            .sheet(isPresented: $viewModel.showingEditView, onDismiss: {
                viewModel.selectedJournal = nil //reset to previous
            }, content: {
                if let selectedJournal = viewModel.selectedJournal {
                    AddJournalView(viewModel: AddEditJournalViewModel(), selectedJournal: selectedJournal)
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

struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView()
    }
}
