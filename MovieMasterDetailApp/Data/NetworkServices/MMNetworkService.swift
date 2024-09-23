//
//  MMNetworkService.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 19/09/2024.
//

import Foundation
import UIKit

protocol NetworkService {
    func sendRequest<T: Decodable, U: Codable>(url: URL, body: U, headerValue: [String:String], for type: T.Type, completion: @escaping (Result<T>) -> Void)
    
    func sendRequest<T: Codable>(url: URL, headerValue: [String:String], for type: T.Type, completion: @escaping (Result<T>) -> Void)
}


class LiveNetworkService : NetworkService{

    // MARK: - BASIC PROPERTIES
    /// Used when the endpoint requires a header-type (i.e. "content-type") be specified in the header
    enum HeaderContentType: String {
        case contentType = "Content-Type"
    }

    /// Used to switch between live and Mock Data
    /// in object-oriented programming, mock objects are simulated objects that mimic the behavior of real objects in controlled ways, most often as part of a software testing initiative.
    var networkClient: MMNetworkClient

    //MARK: - INEJCTION OF URLSESSION OBJECT
    init(networkClient: MMNetworkClient = URLSession.shared) {
        self.networkClient = networkClient
    }

    // MARK: - CREATE API REQUEST
    /// Creating a request with URL and requestMethod
    func createRequest( url: URL?, method: HTTPMethod, headerType: HeaderContentType? = nil, headerValue: [String: String]) -> URLRequest? {
        guard let requestUrl = url else {
            return nil
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headerValue
        return request
    }

  
    
    // MARK: - GENERIC FUNCTION FOR POST REQUEST
    //using <> placeholder type for generics
    public func sendRequest<T: Decodable, U: Codable>(url:URL, body: U,headerValue: [String:String] ,for: T.Type = T.self, completion: @escaping (Result<T>) -> Void) {
        
        guard let request = self.createRequest(url: url, method: .post, headerType: .contentType, headerValue: headerValue) else { print("Error Creating Request. Nil URL?")
            return
        }
        var req = request
        req = encode(from: body, request: request)!
        
        self.networkClient.loadData(using: req) { (data, response, error) in
            guard let data = data else {
                completion(.failure(error?.localizedDescription as! Error))
                return
            }
            let responseData = decode(to: T.self, data: data)
            completion(.success(responseData!))
        }
    }

    public func sendRequest<T: Codable>(url:URL,headerValue: [String:String] ,for: T.Type = T.self, completion: @escaping (Result<T>) -> Void) {
        
        guard let request = self.createRequest(url: url, method: .get, headerValue: headerValue)
        else { print("Error Creating Request. Nil URL?")
            return
        }
        
        self.networkClient.loadData(using: request) { (data, response, error) in
            guard let data = data else {
                completion(.failure(CustomError.message(error?.localizedDescription ?? "no data found") as Error))
                return
            }
            let list = decode(to: T.self, data: data)
            completion(.success(list!))
        }
    }
}


class MockNetworkService : NetworkService{
    var shouldReturnError = false
    
    func sendRequest<T, U>(url: URL, body: U, headerValue: [String : String], for type: T.Type, completion: @escaping (Result<T>) -> Void) where T : Decodable, U : Decodable, U : Encodable {
        
    }
    
    public func sendRequest<T: Codable>(url:URL,headerValue: [String:String] ,for: T.Type = T.self, completion: @escaping (Result<T>) -> Void) {
        let mockError = NSError(domain: "com.example.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock network error"])
        
        if url.absoluteString == "https://api.themoviedb.org/3//movie/popular?api_key=879dcd1fe99c208bd28b4dc495c1a7f4" {
            if shouldReturnError{
                completion(.failure(mockError))
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
                if let list = decode(to: T.self, data: jsonData) {
                    completion(.success(list))
                }else{
                    completion(.failure(CustomError.message("Response Data Is Incorrect") as Error))
                }
            }
            
            //            guard let data = data else {
            //                completion(.failure(CustomError.message(error?.localizedDescription ?? "no data found") as Error))
            //                return
            //            }
            //
        }else{
            completion(.failure(CustomError.message("URL Is Incorrect") as Error))
        }
    }
}


// MARK: - GENERIC DECODE FUNCTION TO DECODE DATA
func decode<T: Decodable>(to type: T.Type, data: Data) -> T? {
    let decoder = JSONDecoder()
    do {
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Error Decoding JSON into \(String(describing: type)) Object \(error)")
        return nil
    }
}

// MARK: - GENERIC ENCODE FUCNTION TO ENCODE DATA
func encode<T: Encodable>(from instance: T, request: URLRequest) -> URLRequest? {
    let jsonEncoder = JSONEncoder()
    var request = request
    do {
        request.httpBody = try jsonEncoder.encode(instance)
        return request
    } catch {
        print("Error encoding object into JSON \(error)")
        return nil
    }
}

enum CustomError: Error {
    case message(String)
}
