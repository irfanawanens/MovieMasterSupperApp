//
//  MoviesRepository.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 20/09/2024.
//

import Foundation


protocol MoviesRepository {
    func MoviesList(completion: @escaping ((Result<MoviesListResponse>) -> ()))
}
