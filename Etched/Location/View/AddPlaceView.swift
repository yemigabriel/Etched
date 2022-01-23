//
//  LocationView.swift
//  Etched
//
//  Created by Yemi Gabriel on 1/11/22.
//

import SwiftUI
import MapKit

struct AddPlaceView: View {
    @StateObject private var viewModel = AddPlaceViewModel()
    @State var journal: JournalMO?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $viewModel.region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: viewModel.annotationItems) { location in
                
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    VStack {
                        Text("Use this location?")
                            .font(.callout.bold())
                            .shadow(radius: 3)
                        
                        HStack {
                            Text(location.name ?? "")
                                .padding(.horizontal)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                            
                            Spacer()
                            
                            Button{
                                viewModel.addLocation(to: journal){}
                                dismiss()
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .frame(width: 200)
                        .background(.background)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                        .offset(y: 25)
                    }
                    .padding(.vertical, 44)
                }
            }
                .ignoresSafeArea()
                .onAppear {
                    viewModel.requestLocation()
                }
                .alert(isPresented: $viewModel.error != nil ) {
                    Alert(error: viewModel.error, primaryButtonTitle: "Settings", secondaryButtonTitle: "Not Now") {
                        self.viewModel.requestLocationSettings()
                    } secondaryAction: {
                        dismiss()
                    }
                    
                }
            
            VStack(spacing: 0) {
                HStack (spacing: 20){
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline.bold())
                    }
                    TextField("Search places", text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { searchText in
                            viewModel.search()
                        }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.background)
                .clipShape(Capsule())
                .shadow(radius: 5)
                
                if viewModel.searchText.isNotEmpty() {
                    List{
                        Label("Use Current Location", systemImage: "location")
                            .font(.callout)
                            .onTapGesture {
                                viewModel.addLocation(to: journal) {}
                                dismiss()
                            }
                        ForEach(viewModel.searchResults, id: \.self) { mapItem in
                            HStack(spacing: 20) {
                                Image(systemName: "location")
                                
                                VStack(alignment: .leading) {
                                    if let name = mapItem.name {
                                        Text(name)
                                            .font(.callout)
                                    }
                                    Text(viewModel.getAddress(for: mapItem.placemark))
                                        .font(.footnote)
                                }
                                .onTapGesture {
                                    addUpdatedLocation(mapItem.placemark, journal: journal)
                                    dismiss()
                                }
                            }
                        }
                    }
                    .offset(y: -30)
                }
                
            }
            .padding()
        }
        
    }
    
    func addUpdatedLocation(_ placemark: MKPlacemark, journal: JournalMO?) {
        viewModel.updateCurrentLocation(with: placemark)
        viewModel.addLocation(to: journal) {}
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView()
    }
}
