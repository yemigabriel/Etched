//
//  AddJournalView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/28/21.
//

import SwiftUI

struct AddJournalView: View {
    @EnvironmentObject private var journalViewModel: JournalViewModel
    @FocusState var isInputActive: Bool
    @State private var showPlaceholder = true
    let placeholder = "Start writing ..."
    
    var body: some View {
        NavigationView {
            //            VStack(alignment: .leading) {
            //                HStack(spacing: 20) {
            //                    Text(Date().formattedShortDate())
            //                        .kerning(2.5)
            //                        .textCase(.uppercase)
            //
            //                }
            //                .font(.title.bold())
            
            ZStack (alignment: .topLeading) {
                TextEditor(text: $journalViewModel.journal.content ?? "")
                    .focused($isInputActive)
                    .onTapGesture {
                        showPlaceholder = false
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isInputActive = false
                                showPlaceholder = (journalViewModel.journal.content ?? "").isEmpty ? true : false
                            }
                        }
                    }
                //            }
                .padding()
                .navigationBarTitle(Date().formattedShortDate())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("mood")
                        } label: {
                            Text("😃")
                                .font(.largeTitle.bold())
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("location")
                        } label: {
                            Image(systemName: "mappin.and.ellipse")
                        }
                    }
                }
                
                Text(showPlaceholder ? placeholder : "")
                    .foregroundColor(.gray)
                    .font(.title2)
                    .padding()
                    .onTapGesture {
                        isInputActive = true
                        showPlaceholder = false
                    }
            }
            
        }
    }
}

//struct AddJournalView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddJournalView()
//    }
//}
