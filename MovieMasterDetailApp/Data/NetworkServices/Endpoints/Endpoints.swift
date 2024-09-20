//
//  Endpoints.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 19/09/2024.
//

import Foundation

protocol EndPoint {
    // MARK: - Vars & Lets
    var baseURL: String { get }
    var path: String { get }
}



enum GalaryEndPoints: CaseIterable {
    // MARK: User actions
    case videoListing
    case videoDetail
}

extension GalaryEndPoints: EndPoint {
       var baseURL: String {
           return Constants.baseUrl
       }
       
       var path: String {
           switch self {
           case .videoListing:
               return "movie/popular?api_key=879dcd1fe99c208bd28b4dc495c1a7f4"
           case .videoDetail:
               return "movie"
           
           }
       }
       
       var httpMethod: HTTPMethod {
           switch self {
           case .videoListing:
               return .post
           case .videoDetail:
               return .post
           
           }
       }
       
       var url: URL? {
           switch self {
           case .videoListing:
               return URL(string: Constants.baseUrl + self.path)!
           case .videoDetail:
               return URL(string: Constants.baseUrl + self.path)!
           }
       }
}
