//
//  UberHandler.swift
//  UberRidder
//
//  Created by MSA on 30/05/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UberHandler {
    private static let _instance = UberHandler()
    
    
    var rider = ""
    var driver = ""
    var rider_id = ""
    
    static var Instance: UberHandler {
        return _instance
    }
    
}
