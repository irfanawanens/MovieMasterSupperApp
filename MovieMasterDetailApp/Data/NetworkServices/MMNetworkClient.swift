//
//  MMNetworkClient.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 19/09/2024.
//

import Foundation


protocol MMNetworkClient {
    func loadData(using request: URLRequest, with completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}

extension URLSession: MMNetworkClient {
    func loadData(using request: URLRequest, with completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.dataTask(with: request) { (data, response, error) in
            // If there's a client error, call completion with the error
            if let error = error {
                print("Client Error: \(error)")
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
                return
            }
            
            // Check if data is nil
            guard let data = data else {
                let noDataError = NSError(domain: "DataErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("Client Error: \(noDataError)")
                DispatchQueue.main.async {
                    completion(nil, nil, noDataError)
                }
                return
            }
            
            // Cast response to HTTPURLResponse
            guard let httpResponse = response as? HTTPURLResponse else {
                let invalidResponseError = NSError(domain: "ResponseErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response received"])
                print("Client Error: \(invalidResponseError)")
                DispatchQueue.main.async {
                    completion(nil, nil, invalidResponseError)
                }
                return
            }
            
            // Check status code
            guard (200...201).contains(httpResponse.statusCode) else {
                // Try to parse the error message from the response data
                let serverErrorMessage: String
                if let errorJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                   let errorDict = errorJSON as? [String: Any],
                   let message = errorDict["status_message"] as? String {
                    serverErrorMessage = message
                } else {
                    serverErrorMessage = "Server error with status code: \(httpResponse.statusCode)"
                }
                
                let serverError = NSError(domain: "ServerErrorDomain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: serverErrorMessage])
                print("Server error: \(serverError.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, httpResponse, serverError)
                }
                return
            }
            
            // If everything is fine, call completion with data and response
            DispatchQueue.main.async {
                print("Server Response: \(httpResponse)")
                completion(data, httpResponse, nil)
            }
        }.resume()
    }
}
