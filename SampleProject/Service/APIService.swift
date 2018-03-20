//
//  APIService.swift
//  SampleProject
//
//  Created by Varun Varman on 01/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import Foundation
protocol APIServiceProtocol {
    func fetchData(_ completionHandler: @escaping ([Product]?, APIServiceError?) -> Void)
}
class APIService: APIServiceProtocol {
    func fetchData(_ completionHandler: @escaping ([Product]?, APIServiceError?) -> Void) {
        // code to fetch some data, maybe a service call
        // ..
        // ..
        // Since we do not have a n API for fetching of products and external JSON file is used
        // Data.json is bundled with project.
        sleep(3)
        guard let filepath = Bundle.main.path(forResource: "Data", ofType: "json") else {
            completionHandler(nil, nil)
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filepath) )
            let jsonDecoder = JSONDecoder()
            do {
                let products = try jsonDecoder.decode(Products.self, from: data)
                DispatchQueue.main.async { // making sure, to, call on main thread.
                    completionHandler(products.products, nil)
                }
            } catch {
                DispatchQueue.main.async { // making sure, to, call on main thread.
                    completionHandler(nil, APIServiceError.dataIncompatible)
                }
            }
        } catch {
            DispatchQueue.main.async { // making sure, to, call on main thread.
                completionHandler(nil, APIServiceError.dataIncompatible)
            }
        }
    }
}

enum APIServiceError: String, Error {
    case noNetwork = "There is no network."
    case connectionFailed = "The connection to fetch data failed."
    case unknown = "Some Unknown Error occoured."
    case dataIncompatible = "There was incompatible data recieved."
}
