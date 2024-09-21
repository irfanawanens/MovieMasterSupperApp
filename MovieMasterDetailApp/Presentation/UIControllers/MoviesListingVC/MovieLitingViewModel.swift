//
//  MovieLitingViewModel.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 20/09/2024.
//

import Foundation

class MovieLitingViewModel {
    
    // MARK: - PROPERTIES
    var errorMessage: Observable<String?> = Observable(nil)
    
    var responseData: Observable<MoviesListResponse> = Observable(nil)
    
   
    var useCase : MoviesUseCase?
    
    init(useCase : MoviesUseCase){
        self.useCase  = useCase
    }
    
    // MARK: - FUNCTIONS
    func getPopularMovies(){
        useCase?.MoviesList(completion: { result in
            switch result{
            case .success(let data):
                self.responseData.property = data
            case .failure(let error):
                self.setError(error.localizedDescription)
            }
        })
    }
    private func setError(_ message: String) {
        self.errorMessage.property = message
    }
}
