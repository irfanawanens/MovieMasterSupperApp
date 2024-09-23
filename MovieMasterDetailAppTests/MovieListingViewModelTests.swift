//
//  MovieListingViewModelTests.swift
//  MovieMasterDetailAppTests
//
//  Created by Muhammad Irfan Awan on 22/09/2024.
//

import XCTest
@testable import MovieMasterDetailApp



final class MovieListingViewModelTests: XCTestCase {
    
    var repo:  MoviesRepository!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        repo = MovieRepositoryImplementation(networkService: MockNetworkService())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        repo = nil
    }

    func test_getPopularMovies_Success() throws {
        let expectation = self.expectation(description: "Response is successful")
        
        repo.MoviesList { result in
            switch result {
            case .success(let moviesList):
                XCTAssertNotNil(moviesList.results, "Movies list should not be nil")
                XCTAssertFalse(moviesList.results!.isEmpty, "Movies list should not be empty")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getPopularMovies_Failure() throws {
        let expectation = self.expectation(description: "Response is expected to fail")
        let mockService = MockNetworkService()
        mockService.shouldReturnError = true
        repo = MovieRepositoryImplementation(networkService: mockService)
        
        repo.MoviesList { result in
            switch result {
            case .success(let moviesList):
                XCTFail("Expected failure but got success with: \(moviesList.results ?? [])")
                
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil")
                print("Received expected error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
