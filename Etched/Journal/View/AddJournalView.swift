//
//  AddJournalView.swift
//  Etched
//
//  Created by Yemi Gabriel on 12/28/21.
//

import SwiftUI

struct AddJournalView: View {
    @StateObject var viewModel = AddEditJournalViewModel()
    @FocusState private var isInputActive: Bool
    @State var selectedJournal: JournalMO?
    
    @Environment(\.dismiss) var dismiss
    
//    init(viewModel: AddEditJournalViewModel = AddEditJournalViewModel()) {
//        print("viewModel init begins")
//        self.viewModel = viewModel
//        print("viewModel init ends")
//    }
    
    let gridColumns = [
        GridItem(.adaptive(minimum: 100))
        ]
    
    @State private var inputImage: UIImage?
    @State private var inputImagePath: String?
    @State private var image: Image?
    
    var body: some View {
        NavigationView {
            ZStack {
//                ScrollView {
                    VStack(alignment: .leading) {
                        //check for add or edit situations
                        if inputImage != nil || viewModel.journal.wrappedSavedImages.isNotEmpty() {
                            ScrollView(.horizontal) {
                                HStack {
                                    image?
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .opacity(0.7)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        ZStack {
                        TextEditor(text: $viewModel.journal.content ?? "")
                            .focused($isInputActive)
                            .padding()
                            .navigationBarTitle(viewModel.journal.wrappedTimestamp.formattedShortDate())
                            .onTapGesture {
                                viewModel.showPlaceholder = false
                            }
                            .toolbar(content: keyboardToolbar)
                            .toolbar {
                                ToolbarItemGroup(placement: .navigationBarLeading) {
                                    Button {
                                        dismiss()
                                    } label: {
                                        Label("Dismiss", systemImage: "xmark")
                                            .font(.headline.bold())
                                    }
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    if viewModel.journal.mood != nil {
                                        Button(viewModel.journal.mood!.emoji!) {}
                                    }
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
//                                    if viewModel.journal.id == nil
//                                    {
                                        Button {
                                            viewModel.add() // Merge policy makes edit possible even with this method
                                            dismiss()
                                        } label: {
                                            Text("Save")
                                                .fontWeight(.bold)
                                        }
                                        .disabled(viewModel.journal.wrappedContent.isEmpty)
//                                    }
                                }
                            }
                            .onChange(of: viewModel.journal.wrappedContent) { vm in
                                print("changed journal...")
                            }
                            .onAppear(perform: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7 ) {
                                    isInputActive = viewModel.isInputActive //@FocusState from VM
                                    isInputActive = true
                                    if let selectedJournal = selectedJournal {
                                        viewModel.journal = selectedJournal
                                        
                                        if let journalImage = UIImage.loadFirst(from: selectedJournal.wrappedSavedImages) {
                                            image = Image(uiImage: journalImage)
                                        }
                                    }
                                }
                            })
                            .blur(radius: viewModel.showMoodAlert ? 20 : 0)

                        Text(viewModel.journal.wrappedContent)
                            .foregroundColor(.gray)
                            .font(.title2)
                            .padding(.all, 8)
                            .opacity(0)
////                            .onTapGesture {
////                                self.viewModel.clearPlaceholder()
////                            }
                        }
                    }
//                }
                if viewModel.showMoodAlert {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(0.5)
                        .onTapGesture {
                            self.viewModel.showMoodAlert.toggle()
                        }
                    
                    LazyVGrid(columns: gridColumns) {
                        ForEach(Journal.moods, id: \.id) { mood in
                            VStack() {
                                Text(mood.emoji)
                                    .font(.largeTitle)
                                Text(mood.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary.opacity(0.7))
                            }
                            .padding()
                            .onTapGesture {
                                viewModel.addMood(mood: mood)
                                viewModel.showMoodAlert.toggle()
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary.opacity(0.3), lineWidth: 2))
                    .cornerRadius(10)
                    .shadow(radius: 20)
                    .padding()
                    
                }
                
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePickerController(image: $inputImage, imagePath: $inputImagePath)
            }
            .onDisappear {
                viewModel.dismissSheet()
            }
            .onChange(of: inputImage) { inputImage in
                addPhoto(inputImage)
            }
            .onChange(of: inputImagePath ?? "", perform: { path in
                if path.isNotEmpty() {
                    viewModel.addImage(at: path)
                }
            })
            
        }
    }
    
    @ToolbarContentBuilder
    func keyboardToolbar() -> some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            HStack {
                ScrollView() {
                    HStack(spacing: 20) {
                        Button {
                            viewModel.showMoodAlert = true
                        } label: {
                            Image(systemName: "face.smiling")
                        }
                        Button {
                            viewModel.showLocation = true
                        } label: {
                            Image(systemName: "mappin.and.ellipse")
                        }
                        Button {
                            viewModel.showImagePicker.toggle()
                        } label: {
                            Image(systemName: "photo")
                        }
                        Button {
                            print("audio")
                        } label: {
                            Image(systemName: "mic")
                        }
                        Button {
                            print("video")
                        } label: {
                            Image(systemName: "video")
                        }
                    }
                }
                Spacer()
                Button("Done") {
                    isInputActive.toggle()
                }
            }
        }
    }
    
    func addPhoto(_ photo: UIImage?) {
        guard let inputImage = photo else { return }
        image = Image(uiImage: inputImage)
    }
    
    func addLocation() {
        /***
         1. Access user location
         2. Save long and lat to core data
         **/
    }
    
    func addMood() {
        /***
         1. Open mood action sheet
         2. on select, add mood to core data
         **/
    }
}

//struct AddJournalView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddJournalView()
//    }
//}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
