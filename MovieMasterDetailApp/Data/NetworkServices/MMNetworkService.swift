//
//  MMNetworkService.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 19/09/2024.
//

import Foundation
import UIKit

class NetworkService {

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
    
    
    // MARK: - GENERIC FUNCTION FOR POST REQUEST
    //using <> placeholder type for generics
    public func sendRequest<T: Decodable, U: Codable>(url:URL, body: U,headerValue: [String:String] ,for: T.Type = T.self, completion: @escaping (Result<T>) -> Void) {
        
        guard let request = self.createRequest(url: url, method: .post, headerType: .contentType, headerValue: headerValue) else { print("Error Creating Request. Nil URL?")
            return
        }
        var req = request
        req = self.encode(from: body, request: request)!
        
        self.networkClient.loadData(using: req) { (data, response, error) in
            guard let data = data else {
                completion(.failure(error?.localizedDescription as! Error))
                return
            }
            let responseData = self.decode(to: T.self, data: data)
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
                completion(.failure(error?.localizedDescription as! Error))
                return
            }
            let list = self.decode(to: T.self, data: data)
            completion(.success(list!))
        }
    }
}
