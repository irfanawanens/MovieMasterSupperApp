//
//  MovieLitingViewModelTests.swift
//  MovieMasterDetailAppTests
//
//  Created by Muhammad Irfan Awan on 22/09/2024.
//

import XCTest
@testable import MovieMasterDetailApp

// Mock MoviesUseCase

class MovieMockRepositoryImplementation: MoviesRepository {
    let networkService: NetworkService
    var shouldReturnError: Bool = false // Mock the api response failure case
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
   
    func MoviesList(completion: @escaping ((Result<MoviesListResponse>) -> ())) {
        
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock failure response"])))
            return
        }
               
        let jsonString = """
         {
           "page": 1,
           "results": [
             {
               "adult": false,
               "backdrop_path": "/path_to_backdrop_image.jpg",
               "genre_ids": [12, 18],
               "id": 12345,
               "original_language": "en",
               "original_title": "Sample Movie Title",
               "overview": "This is a short overview of the movie.",
               "popularity": 234.56,
               "poster_path": "/path_to_poster_image.jpg",
               "release_date": "2024-09-21",
               "title": "Sample Movie Title",
               "video": false,
               "vote_average": 7.5,
               "vote_count": 1500
             },
             {
               "adult": false,
               "backdrop_path": "/another_backdrop_image.jpg",
               "genre_ids": [16, 35],
               "id": 67890,
               "original_language": "fr",
               "original_title": "Un Autre Film",
               "overview": "Une description brève du film.",
               "popularity": 150.32,
               "poster_path": "/another_poster_image.jpg",
               "release_date": "2024-08-15",
               "title": "Un Autre Film",
               "video": false,
               "vote_average": 6.8,
               "vote_count": 850
             }
           ],
           "total_pages": 100,
           "total_results": 2000
         }

         """
        
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                // Create an instance of JSONDecoder
                let decoder = JSONDecoder()
                
                // Decode the JSON data into MovieAttributes
                let moviesList = try decoder.decode(MoviesListResponse.self, from: jsonData)
                
                // Access the model data (Example)
                completion(.success(moviesList))
            } catch {
                completion(.failure(NSError(domain: "Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON: \(error)"])))
            }
        }
        
    }
}


final class MovieLitingViewModelTests: XCTestCase {
    
    var repo:  MoviesRepository!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        repo = MovieMockRepositoryImplementation(networkService: NetworkService())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        repo = nil
    }

    func test_getPopularMovies_Success() throws {
        
        let expectation = expectation(description: "Reponse is successful")

        repo.MoviesList { result in
            switch result{
            case .success(let moviesList):
                print(moviesList.results ?? [])
                expectation.fulfill()
            case .failure(let error):
                assert(false)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getPopularMovies_Failure() throws {
        
        let expectation = self.expectation(description: "Response is expected to fail")
        (repo as! MovieMockRepositoryImplementation).shouldReturnError = true
        
        repo.MoviesList { result in
            switch result {
            case .success(let moviesList):
                XCTFail("Expected failure but got success with: \(moviesList.results ?? [])")
            case .failure(let error):
                print("Received expected error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
           
           wait(for: [expectation], timeout: 5.0)
    }
}
