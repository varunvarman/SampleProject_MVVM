//
//  Constants.swift
//  SampleProject
//
//  Created by Varun Varman on 02/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import Foundation
class Constants {
     struct AlertMessages {
        static let cartAlreadyEmpty: String = "The Checkout cart is already empty."
        static let willRemoveItems: String = "This will remove all products from your cart."
        static let unknownError: String = "Unknown Error occoured."
    }
    struct cellIdentifiers {
        static let listCell: String = "cell"
        static let checkoutCell: String = "checkoutCell"
    }
    struct ViewTitle {
        static let products: String = "Products"
        static let checkout: String = "Checkout"
    }
}
