//
//  MoviesUseCase.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 20/09/2024.
//

import Foundation

protocol MoviesUseCase {
    func MoviesList(completion: @escaping ((Result<MoviesListResponse>) -> ()))
}

class MoviesUseCaseImplementation : MoviesUseCase{
    
    let movieRepository: MoviesRepository
    
    init(repo: MoviesRepository) {
        self.movieRepository = repo
    }
    
    func MoviesList(completion: @escaping ((Result<MoviesListResponse>) -> ())) {
        movieRepository.MoviesList { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

    
    
