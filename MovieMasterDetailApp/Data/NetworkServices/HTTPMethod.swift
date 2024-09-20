//
//  HTTPMethod.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 19/09/2024.
//

import Foundation
// MARK: - HTTP METHODS Enum
enum HTTPMethod: String {
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


// MARK: - to get the request result success/failure
enum Result<T> {
    case success(T) // success result of type generic
    case failure(Error)
}
