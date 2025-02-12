//
//  RickAndMortySearchAppTests.swift
//  RickAndMortySearchAppTests
//
//  Created by Suraj Raju Dhopati on 2/11/25.
//

//import XCTest
//import Combine
//@testable import RickAndMortySearchApp
//
//
//
//// MARK: - Mock API Service
//
//final class MockAPIService: APIServiceProtocol {
//    var shouldReturnError = false
//    var fakeResponse: CharacterResponse?
//    
//    func fetchCharacters(with filters: FilterParameters, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            if self.shouldReturnError {
//                completion(.failure(APIError.noResults))
//            } else if let response = self.fakeResponse {
//                completion(.success(response))
//            } else {
//                let emptyInfo = Info(count: 0, pages: 0, next: nil, prev: nil)
//                completion(.success(CharacterResponse(info: emptyInfo, results: [])))
//            }
//        }
//    }
//    
//    func fetchCharactersByPage(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            if self.shouldReturnError {
//                completion(.failure(APIError.noResults))
//            } else if let response = self.fakeResponse {
//                completion(.success(response))
//            } else {
//                let emptyInfo = Info(count: 0, pages: 0, next: nil, prev: nil)
//                completion(.success(CharacterResponse(info: emptyInfo, results: [])))
//            }
//        }
//    }
//}
//
//// MARK: - Unit Tests for CharacterListViewModel
//
//final class CharacterListViewModelTests: XCTestCase {
//    
//    var viewModel: CharacterListViewModel!
//    var mockService: MockAPIService!
//    var cancellables: Set<AnyCancellable> = []
//    
//    override func setUp() {
//        super.setUp()
//        mockService = MockAPIService()
//        viewModel = CharacterListViewModel(apiService: mockService)
//    }
//    
//    override func tearDown() {
//        viewModel = nil
//        mockService = nil
//        cancellables.removeAll()
//        super.tearDown()
//    }
//    
//
//    func testValidSearchResults() {
//
//        let fakeCharacter = Character(
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
//            url: "https://rickandmortyapi.com/api/character/1",
//            created: "2017-11-04T19:50:28.250Z"
//        )
//        let fakeInfo = Info(count: 1, pages: 1, next: nil, prev: nil)
//        
//        mockService.fakeResponse = CharacterResponse(info: fakeInfo, results: [fakeCharacter])
//        mockService.shouldReturnError = false
//        
//        let expectation = self.expectation(description: "ValidSearchResults")
//        
//        viewModel.$characters
//            .dropFirst() // ignore the initial empty value
//            .sink { characters in
//                print("Received characters count: \(characters.count)")
//                if characters.count == 1 {
//                    XCTAssertNil(self.viewModel.errorMessage, "Expected no error message for valid search")
//                    XCTAssertEqual(characters.first?.name, "Rick Sanchez", "Expected the character name to be 'Rick Sanchez'")
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        let filters = FilterParameters(name: "Rick", status: nil, species: nil, type: nil)
//        viewModel.searchCharacters(filters: filters)
//        
//        waitForExpectations(timeout: 10, handler: nil)
//    }
//
//    
//    
//    func testCharacterResponseDecoding() throws {
//        let jsonString = """
//        {
//            "info": {
//                "count": 1,
//                "pages": 1,
//                "next": null,
//                "prev": null
//            },
//            "results": [{
//                "id": 1,
//                "name": "Rick Sanchez",
//                "status": "Alive",
//                "species": "Human",
//                "type": "",
//                "gender": "Male",
//                "origin": {
//                    "name": "Earth (C-137)",
//                    "url": "https://rickandmortyapi.com/api/location/1"
//                },
//                "location": {
//                    "name": "Citadel of Ricks",
//                    "url": "https://rickandmortyapi.com/api/location/3"
//                },
//                "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
//                "episode": [],
//                "url": "https://rickandmortyapi.com/api/character/1",
//                "created": "2017-11-04T18:48:46.250Z"
//            }]
//        }
//        """
//        let jsonData = jsonString.data(using: .utf8)!
//        let decoder = JSONDecoder()
//        let response = try decoder.decode(CharacterResponse.self, from: jsonData)
//        XCTAssertEqual(response.results.count, 1, "Expected one character in the response")
//        XCTAssertEqual(response.results.first?.name, "Rick Sanchez", "Expected the character name to be 'Rick Sanchez'")
//    }
//    
//    func testNoResultsError() {
//        let filters = FilterParameters(name: "Zamd", status: nil, species: nil, type: nil)
//        mockService.shouldReturnError = true
//        
//        let apiExpectation = expectation(description: "APIServiceNoResults")
//        let viewModelExpectation = expectation(description: "ViewModelNoResults")
//        
//        APIService.shared.fetchCharacters(with: filters) { result in
//            switch result {
//            case .success(let response):
//                XCTAssertTrue(response.results.isEmpty, "Expected no results")
//                apiExpectation.fulfill()
//            case .failure(let error):
//                XCTAssertEqual(error.localizedDescription, APIError.noResults.errorDescription, "Expected a 'No results found.' error")
//                apiExpectation.fulfill()
//            }
//        }
//        
//        viewModel.$errorMessage
//            .dropFirst()
//            .filter { $0 != nil }
//            .first()
//            .sink { error in
//                XCTAssertEqual(error, APIError.noResults.errorDescription, "Expected error message to be 'No results found.'")
//                XCTAssertEqual(self.viewModel.characters.count, 0, "Expected no characters in the results")
//                viewModelExpectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        viewModel.searchCharacters(filters: filters)
//        
//        wait(for: [apiExpectation, viewModelExpectation], timeout: 5)
//    }
//    
//}


import XCTest
import Combine
@testable import RickAndMortySearchApp

// MARK: - Mock API Service (Supports async/await)
final class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var fakeResponse: CharacterResponse?
    
    func fetchCharacters(with filters: FilterParameters) async throws -> CharacterResponse {
        try await Task.sleep(nanoseconds: 100_000_000) // Simulate network delay
        if shouldReturnError {
            throw APIError.noResults
        }
        return fakeResponse ?? CharacterResponse(info: Info(count: 0, pages: 0, next: nil, prev: nil), results: [])
    }
    
    func fetchCharactersByPage(page: Int) async throws -> CharacterResponse {
        try await Task.sleep(nanoseconds: 100_000_000) // Simulate network delay
        if shouldReturnError {
            throw APIError.noResults
        }
        return fakeResponse ?? CharacterResponse(info: Info(count: 0, pages: 0, next: nil, prev: nil), results: [])
    }
}

// MARK: - Unit Tests for CharacterListViewModel
@MainActor
final class CharacterListViewModelTests: XCTestCase {
    
    var viewModel: CharacterListViewModel!
    var mockService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        viewModel = CharacterListViewModel(apiService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testValidSearchResults() async throws {
        let fakeCharacter = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
            location: Location(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [],
            url: "https://rickandmortyapi.com/api/character/1",
            created: "2017-11-04T19:50:28.250Z"
        )
        let fakeInfo = Info(count: 1, pages: 1, next: nil, prev: nil)
        
        mockService.fakeResponse = CharacterResponse(info: fakeInfo, results: [fakeCharacter])
        mockService.shouldReturnError = false
        
        let expectation = XCTestExpectation(description: "ValidSearchResults")
        
        await viewModel.searchCharacters(filters: FilterParameters(name: "Rick", status: nil, species: nil, type: nil))
        
        // Allow async updates
        try await Task.sleep(nanoseconds: 200_000_000)
        
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 5.0)
        
        XCTAssertEqual(viewModel.characters.count, 1, "Expected one character in search results")
        XCTAssertEqual(viewModel.characters.first?.name, "Rick Sanchez", "Expected the character name to be 'Rick Sanchez'")
        XCTAssertNil(viewModel.errorMessage, "Expected no error message for valid search")
    }
    
    func testCharacterResponseDecoding() throws {
        let jsonString = """
        {
            "info": {
                "count": 1,
                "pages": 1,
                "next": null,
                "prev": null
            },
            "results": [{
                "id": 1,
                "name": "Rick Sanchez",
                "status": "Alive",
                "species": "Human",
                "type": "",
                "gender": "Male",
                "origin": {
                    "name": "Earth (C-137)",
                    "url": "https://rickandmortyapi.com/api/location/1"
                },
                "location": {
                    "name": "Citadel of Ricks",
                    "url": "https://rickandmortyapi.com/api/location/3"
                },
                "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                "episode": [],
                "url": "https://rickandmortyapi.com/api/character/1",
                "created": "2017-11-04T18:48:46.250Z"
            }]
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(CharacterResponse.self, from: jsonData)
        XCTAssertEqual(response.results.count, 1, "Expected one character in the response")
        XCTAssertEqual(response.results.first?.name, "Rick Sanchez", "Expected the character name to be 'Rick Sanchez'")
    }
    
    func testNoResultsError() async throws {
        mockService.shouldReturnError = true

        let expectation = XCTestExpectation(description: "NoResultsError")
        var cancellable: AnyCancellable?

        // Observe errorMessage updates
        cancellable = viewModel.$errorMessage
            .dropFirst()  // Ignore initial value
            .sink { error in
                if error != nil {
                    expectation.fulfill()
                }
            }

        await viewModel.searchCharacters(filters: FilterParameters(name: "Zamd", status: nil, species: nil, type: nil))

        await fulfillment(of: [expectation], timeout: 5.0)

        XCTAssertEqual(viewModel.errorMessage, APIError.noResults.errorDescription, "Expected error message to be 'No results found.'")
        XCTAssertEqual(viewModel.characters.count, 0, "Expected no characters in the results")

        cancellable?.cancel()  // Cleanup subscription
    }

}
