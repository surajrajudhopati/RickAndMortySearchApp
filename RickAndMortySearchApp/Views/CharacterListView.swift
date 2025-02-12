//
//  CharacterListView.swift
//  RickAndMortySearchApp
//
//  Created by Suraj Raju Dhopati on 2/11/25.
//

import SwiftUI

enum SearchFilter: String, CaseIterable, Identifiable {
    case name = "Name"
    case status = "Status"
    case species = "Species"
    case type = "Type"
    
    var id: String { self.rawValue }
}

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    @State private var searchText: String = ""
    @State private var selectedFilter: SearchFilter = .name
    @State private var isGridView: Bool = false
    @State private var lastSelectedCharacterId: Int? = nil
    @State private var hasRestoredScrollPosition: Bool = false
    @Namespace private var animation
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding([.leading, .trailing])
                }
                Group {
                    if isGridView {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(viewModel.characters, id: \.id) { character in
                                    NavigationLink(destination: CharacterDetailView(character: character, namespace: animation)) {
                                        GridCell(character: character, namespace: animation)
                                            .accessibilityIdentifier("GridCell")
                                    }
                                    .simultaneousGesture(TapGesture().onEnded {
                                        lastSelectedCharacterId = character.id
                                        hasRestoredScrollPosition = false
                                    })
                                    .onAppear {
                                        if viewModel.characters.last?.id == character.id && searchText.isEmpty {
                                            viewModel.loadNextPage()
                                        }
                                    }
                                }
                            }
                            .padding()
                            
                            if viewModel.isLoading {
                                HStack {
                                    Spacer()
                                    ProgressView("Loading more...")
                                    Spacer()
                                }
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)))
                    } else {
                        ScrollViewReader { proxy in
                            List {
                                ForEach(viewModel.characters, id: \.id) { character in
                                    NavigationLink(destination: CharacterDetailView(character: character, namespace: animation)) {
                                        CharacterRowView(character: character, namespace: animation)
                                            .id(character.id)
                                            .opacity(lastSelectedCharacterId == character.id ? 1 : 1)
                                    }
                                    .simultaneousGesture(TapGesture().onEnded {
                                        lastSelectedCharacterId = character.id
                                        hasRestoredScrollPosition = false
                                    })
                                    .onAppear {
                                        if viewModel.characters.last?.id == character.id && searchText.isEmpty {
                                            viewModel.loadNextPage()
                                        }
                                    }
                                }
                                
                                if viewModel.isLoading {
                                    HStack {
                                        Spacer()
                                        ProgressView("Loading more...")
                                        Spacer()
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .onAppear {
                                if let selectedID = lastSelectedCharacterId, !hasRestoredScrollPosition {
                                    withAnimation {
                                        proxy.scrollTo(selectedID, anchor: .center)
                                    }
                                    hasRestoredScrollPosition = true
                                }
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)))
                    }
                }
                .animation(.easeInOut(duration: 0.4), value: isGridView)
            }
            .navigationTitle("Rick & Morty")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("Search by \(selectedFilter.rawValue)")
            )
            .onChange(of: searchText) { _ in
                Task {
                    await performSearch()
                }
            }
            .onAppear {
                if searchText.isEmpty && viewModel.characters.isEmpty {
                    viewModel.loadInitialPage()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Menu {
                            ForEach(SearchFilter.allCases) { filter in
                                Button(action: {
                                    selectedFilter = filter
                                    Task {
                                            await performSearch()
                                        }
                                }) {
                                    if selectedFilter == filter {
                                        Label(filter.rawValue, systemImage: "checkmark")
                                    } else {
                                        Text(filter.rawValue)
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                        .accessibilityLabel("Filter")
                        
                        // Toggle view mode button.
                        Button(action: {
                            withAnimation {
                                isGridView.toggle()
                            }
                        }) {
                            Image(systemName: isGridView ? "list.bullet.circle" : "circle.grid.3x3.circle")
                        }
                        .accessibilityLabel("Toggle Grid View")
                    }
                }
            }
        }
    }
    
    private func performSearch() async {
        if searchText.isEmpty {
            await viewModel.resetAndLoadInitialPage()
        } else {
            var filters = FilterParameters(name: nil, status: nil, species: nil, type: nil)
            switch selectedFilter {
            case .name:
                filters = FilterParameters(name: searchText, status: nil, species: nil, type: nil)
            case .status:
                filters = FilterParameters(name: nil, status: searchText, species: nil, type: nil)
            case .species:
                filters = FilterParameters(name: nil, status: nil, species: searchText, type: nil)
            case .type:
                filters = FilterParameters(name: nil, status: nil, species: nil, type: searchText)
            }

            await viewModel.searchCharacters(filters: filters)
        }
    }

}
