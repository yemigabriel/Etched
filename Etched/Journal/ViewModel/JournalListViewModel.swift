//
//  JournalViewModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/26/21.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class JournalListViewModel: ObservableObject {
    
    @Published var journals = [JournalMO]()
    @Published var selectedIndex = 0
    @Published var showingEditView = false
    @Published var showDetailView = false
    @Published var showDeleteAlert = false
    @Published var selectedJournal: JournalMO?
    
    private var cancellable: AnyCancellable?
    
    init(journalPublisher: AnyPublisher<[JournalMO], Never> =
         CoreDataHelper.shared.journals.eraseToAnyPublisher()) {
        cancellable = journalPublisher.sink(receiveValue: { [weak self] journals in
            DispatchQueue.main.async {
                self?.journals = journals.filter{$0.id != nil}
            }
        })
    }
    
    func filter(by filter: String) {
        
    }
    
    func delete() {
        CoreDataHelper.shared.delete(journal: journals[selectedIndex])
    }
    
}
