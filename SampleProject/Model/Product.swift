//
//  Product.swift
//  SampleProject
//
//  Created by Varun Varman on 01/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import Foundation
struct Product: Codable {
    let productName: String
    let productPrice: Int
}

struct Products: Codable {
    let products: [Product]
}
