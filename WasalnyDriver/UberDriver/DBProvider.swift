//
//  DBProvider.swift
//  UberDriver
//
//  Created by MSA on 29/05/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    private static let _instance = DBProvider()
    
    var driver_id = "";
    
    static var Instance: DBProvider{
        return _instance
    }
    
    var DBRef: DatabaseReference{
        return Database.database().reference()
    }
    
    var DriversRef: DatabaseReference{
        return DBRef.child(Constants.DRIVERS)
    }
    
    var RequestRef: DatabaseReference{
        return DBRef.child(Constants.UBER_REQUEST)
    }
    
    var RequestAccepted: DatabaseReference{
        return DBRef.child(Constants.UBER_ACCEPTED)
    }
    
    func SaveUser(Fname: String, Lname: String, PNumber: String, ID: String, Email: String, Password: String, CCN: String, CarType: String, CarColor: String, CarModel: String, PlateNumber: String)
    {
        let data: Dictionary<String,Any> = [Constants.FIRST_NAME: Fname, Constants.LAST_NAME: Lname, Constants.PHONE_NUM: PNumber ,Constants.EMAIL: Email, Constants.PASSWORD: Password, Constants.isRider: false, Constants.BANK_NUM: CCN, Constants.CAR_TYPE: CarType, Constants.CAR_Color: CarColor, Constants.CAR_MODEL: CarModel, Constants.PLATE_NUM: PlateNumber]
        
        DriversRef.child(ID).child(Constants.DATA).setValue(data)
    }
}
