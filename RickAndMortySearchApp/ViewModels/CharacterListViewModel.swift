//
//  CharacterListViewModel.swift
//  RickAndMortySearchApp
//
//  Created by Suraj Raju Dhopati on 2/11/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var hasLoadedData: Bool = false
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    func loadInitialPage() {
        Task {
            do {
                isLoading = true
                let response = try await apiService.fetchCharactersByPage(page: 1)
                self.characters = response.results
                self.totalPages = response.info.pages
                self.currentPage = 1
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func loadNextPage() {
        guard currentPage < totalPages else { return }

        Task {
            do {
                isLoading = true
                let response = try await apiService.fetchCharactersByPage(page: currentPage + 1)
                self.characters.append(contentsOf: response.results)
                self.currentPage += 1
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func searchCharacters(filters: FilterParameters) async {
            isLoading = true
            errorMessage = nil

            do {
                let response = try await apiService.fetchCharacters(with: filters)
                characters = response.results
            } catch let error as APIError {
                errorMessage = error.errorDescription
            } catch {
                errorMessage = "Unexpected error occurred."
            }

            isLoading = false
        }
    
    func resetAndLoadInitialPage() async {
            isLoading = true
            characters.removeAll()
            errorMessage = nil

            do {
                let response = try await apiService.fetchCharactersByPage(page: 1)
                characters = response.results
            } catch let error as APIError {
                errorMessage = error.errorDescription
            } catch {
                errorMessage = "Unexpected error occurred."
            }

            isLoading = false
        }
}
