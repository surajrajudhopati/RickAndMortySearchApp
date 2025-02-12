//
//  APIError.swift
//  RickAndMortySearchApp
//
//  Created by Suraj Raju Dhopati on 2/11/25.
//

import Foundation

protocol APIServiceProtocol {
    func fetchCharacters(with filters: FilterParameters) async throws -> CharacterResponse
    func fetchCharactersByPage(page: Int) async throws -> CharacterResponse
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingError
    case noResults
    case networkDisconnected

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed:
            return "No results found." //"The network request failed."
        case .decodingError:
            return "Failed to decode the response."
        case .noResults:
            return "No results found."
        case .networkDisconnected:
            return "No internet connection. Please try again later."
        }
    }
}

final class APIService: APIServiceProtocol {
    static let shared = APIService()
    private init() {}

    func fetchCharacters(with filters: FilterParameters) async throws -> CharacterResponse {
        var urlComponents = URLComponents(string: "https://rickandmortyapi.com/api/character/")!
        var queryItems = [URLQueryItem]()

        if let name = filters.name, !name.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: name))
        }
        if let status = filters.status, !status.isEmpty {
            queryItems.append(URLQueryItem(name: "status", value: status))
        }
        if let species = filters.species, !species.isEmpty {
            queryItems.append(URLQueryItem(name: "species", value: species))
        }
        if let type = filters.type, !type.isEmpty {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }

        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        return try await fetchData(from: url)
    }

    func fetchCharactersByPage(page: Int) async throws -> CharacterResponse {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character?page=\(page)") else {
            throw APIError.invalidURL
        }

        return try await fetchData(from: url)
    }

    private func fetchData(from url: URL) async throws -> CharacterResponse {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed
            }

            if httpResponse.statusCode == 404 {
                throw APIError.noResults
            } else if !(200...299).contains(httpResponse.statusCode) {
                throw APIError.requestFailed
            }

            do {
                return try JSONDecoder().decode(CharacterResponse.self, from: data)
            } catch {
                throw APIError.decodingError
            }
        } catch {
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                throw APIError.networkDisconnected
            } else {
                throw APIError.requestFailed
            }
        }
    }
}
