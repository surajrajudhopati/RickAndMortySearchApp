//
//  CharacterRowView.swift
//  RickAndMortySearchApp
//
//  Created by Suraj Raju Dhopati on 2/11/25.
//
import SwiftUI

struct CharacterRowView: View {
    let character: Character
    var namespace: Namespace.ID?
    @State private var imageReloadKey: UUID = UUID()
    
    var body: some View {
            HStack {
                AsyncImage(url: URL(string: character.image)) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        //                        .modifier(MatchedGeometryModifier(namespace: namespace, id: "image\(character.id)"))
                            .matchedGeometryEffect(id: "image\(character.id)", in: namespace!, isSource: false)
                        
                        
                        
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .onTapGesture {
                                imageReloadKey = UUID()  // Generate a new ID to force refresh
                            }
                    } else {
                        ProgressView().frame(width: 60, height: 60)
                    }
                }
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.headline)
                    Text(character.species)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .contentShape(Rectangle())
            .padding(.vertical, 5)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(character.name), \(character.species)")
            .accessibilityHint("Double-tap to view details")
            // Report the vertical position using a GeometryReader.
            .background(
                LazyVStack {
                    GeometryReader { proxy in
                        let minY = proxy.frame(in: .global).minY
                        let safeMinY = minY.isNaN ? 0 : minY
                        Color.clear.preference(
                            key: TopRowPreferenceKey.self,
                            value: TopRowPreferenceData(id: character.id, minY: safeMinY)
                        )
                    }
                }
            )
        }
    }

struct MatchedGeometryModifier: ViewModifier {
    var namespace: Namespace.ID?
    var id: String
    
    func body(content: Content) -> some View {
        if let ns = namespace {
            content.matchedGeometryEffect(id: id, in: ns)
        } else {
            content
        }
    }
}
