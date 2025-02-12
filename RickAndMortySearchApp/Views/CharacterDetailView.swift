//
//  CharacterDetailView.swift
//  RickAndMortySearchApp
//
//  Created by Suraj Raju Dhopati on 2/11/25.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    var namespace: Namespace.ID
    @State private var isShareSheetPresented = false
    
    private var formattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: character.created) else {
            return character.created
        }
        let displayFormatter = DateFormatter()
//        displayFormatter.dateFormat = "MM/dd/yyyy 'at' hh:mm a"
        displayFormatter.dateFormat = "MMMM d, yyyy 'at' h:mm a"
        return displayFormatter.string(from: date)
    }
    
    private var shareItems: [Any] {
        let metadata = """
        \(character.name)
        Species: \(character.species)
        Status: \(character.status)
        Origin: \(character.origin.name)
        Created: \(formattedDate)
        """
        var items: [Any] = [metadata]
        if let imageUrl = URL(string: character.image) {
            items.append(imageUrl)
        }
        return items
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: character.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
//                            .matchedGeometryEffect(id: "image\(character.id)", in: namespace)
                            .matchedGeometryEffect(id: "image-\(character.id)", in: namespace)
                            .accessibilityLabel("Image of \(character.name)")
                    } else if phase.error != nil {
                        Color.gray
                            .frame(height: 200)
                            .overlay(Text("Image failed to load").foregroundColor(.white))
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.name).font(.largeTitle).bold()
                    Text("Species: \(character.species)").font(.headline)
                    Text("Status: \(character.status)").font(.subheadline)
                    Text("Origin: \(character.origin.name)").font(.subheadline)
                    if !character.type.isEmpty {
                        Text("Type: \(character.type)").font(.subheadline)
                    }
                    Text("Created: \(formattedDate)").font(.subheadline)
                    .matchedGeometryEffect(id: "name-\(character.id)", in: namespace)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(character.name), \(character.species), \(character.status), Origin \(character.origin.name), Created on \(formattedDate)")

                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShareSheetPresented = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Share character")
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheet(activityItems: shareItems)
        }
    }
}

//struct CharacterDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            CharacterDetailView(character: Character(
//                id: 1,
//                name: "Rick Sanchez",
//                status: "Alive",
//                species: "Human",
//                type: "",
//                gender: "Male",
//                origin: Origin(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
//                location: Location(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
//                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
//                episode: [],
//                url: "",
//                created: "2017-11-04T19:50:28.250Z"
//            ), namespace: Namespace().wrappedValue)
//        }
//    }
//}
