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
                if error != nil || data == nil {
                    print("Client Error: \(String(describing: error))")
                        return
                    }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error with description:\(response?.description ?? " details not found")")
                        return
                }
                DispatchQueue.main.async {
                    print("Server Response :\(response)")
                    completion(data, response, error)
                }
            }.resume()
        
    }
}
