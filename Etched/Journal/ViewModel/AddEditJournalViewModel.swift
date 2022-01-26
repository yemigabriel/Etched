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
    
    @Published var journal: JournalMO = JournalMO(context: CoreDataHelper.shared.container.viewContext)
    @Published var contentHasChanged = false
    @Published var showPlaceholder = true
    @Published var isInputActive = true
    
    @Published var showMoodAlert = false
    @Published var showLocation = false
    @Published var showImagePicker = false
    @Published var isCamera = false
    @Published var isPhotoLibrary = false
    
    
    private var cancellable: AnyCancellable?
    
    let placeholder = "Start writing ..."
    
//    private var coreDataHelper: CoreDataHelper
    
    init(journalPublisher: AnyPublisher<JournalMO, Never> = CoreDataHelper.shared.journal.eraseToAnyPublisher()
         ) {
//        isInputActive = false
        print("viewModel source init begins")
        cancellable = journalPublisher.sink(receiveValue: { value in
            print("UPDATED JOURNAL: \(value.wrappedId)")
            DispatchQueue.main.async {
                self.journal = value
            }
        })
    }

    func add() {
        if journal.id == nil {
            CoreDataHelper.shared.add(journal: journal)
        } else {
            edit()
        }
    }
    
    func edit() {
        CoreDataHelper.shared.edit(journal: journal)
    }
    
    func clearJournal(){
        CoreDataHelper.shared.delete(journal: journal)
    }
    
    // Rolls back uncomitted changes
    func rollBack() {
        CoreDataHelper.shared.container.viewContext.rollback()
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
    
    func addLocation() {
        
    }
    
    
}

extension AddEditJournalViewModel: Equatable {
    static func == (lhs: AddEditJournalViewModel, rhs: AddEditJournalViewModel) -> Bool {
        lhs.journal == rhs.journal
    }
}
