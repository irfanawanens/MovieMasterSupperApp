//
//  MovieListDIContainer.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 19/09/2024.
//

import Foundation

final class MoviesDIContainer {
    
    // MARK: - View model
    func movieLitingViewModel() -> MovieLitingViewModel{
        return MovieLitingViewModel(useCase: moviesUseCase())
    }
   
    // MARK: - UseCases
    private func moviesUseCase() -> MoviesUseCase {
        return MoviesUseCaseImplementation(repo: moviesRepository())
    }
    
  
    // MARK: - Repository
    private func moviesRepository() -> MoviesRepository {
        return MovieRepositoryImplementation(networkService: NetworkService())
    }
}
