//
//  MMCache.swift
//  MovieMasterDetailApp
//
//  Created by Muhammad Irfan Awan on 21/09/2024.
//

import Foundation
class MMCache : NSObject {
        
    static var shared = MMCache()
    
    func saveApiResponse(key:String) {
        
        
    }
    
    func getApiResponse(key:String) {
        
    }
    
    func deleteApiResponse() {
        
    }
    
}


struct CacheMainObject<T: Codable>: Codable {
    
    var savedTime: String?
    var object: T?
}
