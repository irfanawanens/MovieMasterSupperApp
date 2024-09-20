//
//  MovieRepositoryImpl.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 20/09/2024.
//

import Foundation


class MovieRepositoryImplementation: MoviesRepository {
    
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
   
    func MoviesList(completion: @escaping ((Result<MoviesListResponse>) -> ())) {
        networkService.sendRequest(url: GalaryEndPoints.videoListing.url!, headerValue: RequestHeaders.getDefaultHeaders(), for: MoviesListResponse.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
