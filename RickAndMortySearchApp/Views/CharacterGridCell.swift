//
//  GridCell.swift
//  RickAndMortySearchApp
//
//  Created by Suraj Raju Dhopati on 2/11/25.
//

import SwiftUI

struct GridCell: View {
    let character: Character
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: character.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
//                        .matchedGeometryEffect(id: "image\(character.id)", in: namespace)
                        .matchedGeometryEffect(id: "image-\(character.id)", in: namespace)

                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                } else {
                    ProgressView().frame(width: 100, height: 100)
                }
            }
            Text(character.name).font(.headline).foregroundColor(.primary)
            Text(character.species).font(.subheadline).foregroundColor(.secondary)
            .matchedGeometryEffect(id: "name-\(character.id)", in: namespace)
        }
        .padding(8)
        .accessibilityIdentifier("GridCell")
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

//struct GridCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GridCell(character: Character(
//            id: 1,
//            name: "Rick Sanchez",
//            status: "Alive",
//            species: "Human",
//            type: "",
//            gender: "Male",
//            origin: Origin(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
//            location: Location(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
//            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
//            episode: [],
//            url: "",
//            created: "2017-11-04T19:50:28.250Z"
//        ), namespace: Namespace().wrappedValue)
//        .previewLayout(.sizeThatFits)
//    }
//}

