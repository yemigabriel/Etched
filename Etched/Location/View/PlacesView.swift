//
//  PlacesView.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/20/22.
//

import SwiftUI
import MapKit

struct PlacesView: View {
    @StateObject var viewModel = PlacesViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.places) { mapItem in
                MapAnnotation(coordinate: mapItem.coordinate) {
                    VStack {
                        if let journalWithMedia = mapItem.wrappedJournals.filter{$0.wrappedImages.isNotEmpty()} , let image = UIImage.loadFirst(from: journalWithMedia.first?.wrappedImages ?? []) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                        } else {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                                .foregroundColor(.purple)
                                .onTapGesture {
                                    viewModel.showCallout.toggle()
                                    viewModel.selectedPlace = mapItem
                                }
                        }
                        
                    }
                }
            }
            if let selectedJournal = viewModel.selectedJournal {
                NavigationLink("", isActive: $viewModel.showDetail){
                    JournalDetailView(viewModel: DetailViewModel(journal: selectedJournal))
                }
            }
            
            if let selectedPlace = viewModel.selectedPlace, viewModel.showCallout {
                Color(uiColor: UIColor.secondaryLabel)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.showCallout.toggle()
                    }
                
                VStack(alignment: .leading) {
                    ForEach(selectedPlace.wrappedJournals, id: \.self) { journal in
                        HStack {
                            Text(journal.wrappedContent)
                                .font(.footnote)
                                .lineLimit(1)
                            Spacer()
                            Image(systemName: "chevron.right.circle.fill")
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .onTapGesture {
                            viewModel.showDetail = true
                            viewModel.selectedJournal = journal
                        }
                    }
                }
                .frame(width: 200)
                .background(Color(uiColor: UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .onAppear(perform: {
            viewModel.showCallout = false
        })
        .navigationTitle("Places")
    }
}

struct PlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView()
    }
}
