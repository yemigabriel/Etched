//
//  AddEditJournalViewModel.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/30/21.
//

import Foundation
//import SwiftUI
import Combine


class AddEditJournalViewModel: ObservableObject {
    
    @Published var journal: JournalMO
    @Published var contentHasChanged = false
    @Published var showPlaceholder = true
    @Published var isInputActive = true
    
    @Published var showMoodAlert = false
    @Published var showLocation = false
    @Published var showImagePicker = false
    
    
    private var cancellable: AnyCancellable?
    
    let placeholder = "Start writing ..."
    
    private var coreDataHelper: CoreDataHelper
    
    init(journalPublisher: AnyPublisher<JournalMO, Never> = CoreDataHelper.shared.journal.eraseToAnyPublisher()
         ) {
        coreDataHelper = CoreDataHelper.shared
        journal = JournalMO(context: coreDataHelper.container.viewContext)
//        isInputActive = false
        print("viewModel source init begins")
        cancellable = journalPublisher.sink(receiveValue: { journal in
            print("UPDATED JOURNAL: \(journal.wrappedId)")
            DispatchQueue.main.async {
                self.journal = journal
            }
        })
    }
    
//    init(journalPublisher: AnyPublisher<JournalMO, Never> =
//         CoreDataHelper.shared.journal.eraseToAnyPublisher()) {
//
//        cancellable = journalPublisher.sink(receiveValue: { journals in
//            print("UPDATED JOURNAL COUNT: \(journals.count)")
//            DispatchQueue.main.async {
//                self.journals = journals
//            }
//        })
//    }
    
    
    func add() {
        if journal.id == nil {
            coreDataHelper.add(journal: journal)
        } else {
            edit()
        }
    }
    
    func edit() {
        coreDataHelper.edit(journal: journal)
    }
    
    func clearJournal(){
        coreDataHelper.delete(journal: journal)
    }
    
    // Rolls back uncomitted changes
    func rollBack() {
        coreDataHelper.container.viewContext.rollback()
    }
    
    func removeFocus() {
        isInputActive = false
        showPlaceholder = (journal.content ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? true : false
    }
    
    func clearPlaceholder() {
        isInputActive = true
        showPlaceholder = false
    }
    
    func dismissSheet() {
        if (journal.id == nil) ||
            journal.wrappedContent.isEmpty
        {
            clearJournal()
        }
        rollBack()
    }
    
    func toggleEdit() {
        isInputActive = !isInputActive
    }
    
    func addMood(mood: Mood) {
        if journal.mood == nil {
            journal.mood = MoodMO(context: PersistenceController.shared.container.viewContext)
        }
        journal.mood!.id = mood.id
        journal.mood!.name = mood.name
        journal.mood!.emoji = mood.emoji
    }
    
    func addImage(at path: String) {
//    TODO: multiple images
//        var images = [String]()
//        images.append(contentsOf: journal.wrappedImages)
//        images.append(path)
        journal.images = path
    }
    
    
}

extension AddEditJournalViewModel: Equatable {
    static func == (lhs: AddEditJournalViewModel, rhs: AddEditJournalViewModel) -> Bool {
        lhs.journal == rhs.journal
    }
}
