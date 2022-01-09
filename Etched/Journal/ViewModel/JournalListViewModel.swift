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
    private var cancellable: AnyCancellable?
    
    init(journalPublisher: AnyPublisher<[JournalMO], Never> =
         CoreDataHelper.shared.journals.eraseToAnyPublisher()) {
        cancellable = journalPublisher.sink(receiveValue: { journals in
            print("UPDATED JOURNAL COUNT: \(journals.count)")
            DispatchQueue.main.async {
                self.journals = journals
            }
        })
    }
    
    func filter(by filter: String) {
        
    }
    
//    func addSampleJournals() {
//        for sampleJournal in Journal.sampleJournals {
//            let journalMO = JournalMO(context: managedObjectContext)
//            journalMO.id = sampleJournal.id
//            journalMO.content = sampleJournal.content
//            journalMO.timestamp = sampleJournal.timestamp
//            journalMO.images = sampleJournal.images?.joined(separator: ",") ?? nil
//            journalMO.audio = sampleJournal.audio
//            journalMO.video = sampleJournal.video
//            if let sampleJournalLocation = sampleJournal.location {
//                journalMO.location = LocationMO(context: managedObjectContext)
//                journalMO.location?.id =  sampleJournalLocation.id
//                journalMO.location?.name =  sampleJournalLocation.name
//                journalMO.location?.latitude =  sampleJournalLocation.latitude ?? 0
//                journalMO.location?.longitude =  sampleJournalLocation.longitude ?? 0
//            }
//
//            if let sampleJournalMood = sampleJournal.mood {
//                journalMO.mood = MoodMO(context: managedObjectContext)
//                journalMO.mood?.id = sampleJournalMood.id
//                journalMO.mood?.name = sampleJournalMood.name
//                journalMO.mood?.emoji = sampleJournalMood.emoji
//            }
//        }
//        do {
//            try managedObjectContext.save()
//        } catch {
//            print(error)
//            print("Error saving MOC: \(error.localizedDescription)")
//        }
//    }
    
    func delete(journal: JournalMO) {
        CoreDataHelper.shared.delete(journal: journal)
    }
    
//    func deleteAll() {
//        for journal in journals {
//            managedObjectContext.delete(journal)
//        }
//        try? managedObjectContext.save()
//    }
}
