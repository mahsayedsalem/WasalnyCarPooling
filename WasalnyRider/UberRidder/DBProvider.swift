//
//  DBProvider.swift
//  UberRidder
//
//  Created by MSA on 29/05/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    private static let _instance = DBProvider()
    var rider_id = "";
    
    static var Instance: DBProvider{
        return _instance
    }
    
    var DBRef: DatabaseReference{
        return Database.database().reference()
    }
    
    var RidersRef: DatabaseReference{
        return DBRef.child(Constants.RIDERS)
    }
    
    var requestRef: DatabaseReference{
        return DBRef.child(Constants.UBER_REQUEST)
    }
    
    var RequestAccepted: DatabaseReference{
        return DBRef.child(Constants.UBER_ACCEPTED)
    }
    
    var AddToHistory : DatabaseReference{
        return RidersRef.child(rider_id).child(Constants.HISTORY);
    }
    
    func SaveUser(Fname: String, Lname: String, PNumber: String, ID: String, Email: String, Password: String, CCN: String)
    {
        let Data: Dictionary<String,Any> = [Constants.FIRST_NAME: Fname, Constants.LAST_NAME: Lname, Constants.PHONE_NUM: PNumber ,Constants.EMAIL: Email, Constants.PASSWORD: Password, Constants.isRider: true, Constants.BANK_NUM: CCN, Constants.RIDES_COUNT: 0]
        
        RidersRef.child(ID).child(Constants.DATA).setValue(Data)
    }
    
    
    func UpdatePassword (Password: String)
    {
        DBProvider.Instance.RidersRef.child(DBProvider.Instance.rider_id).child(Constants.DATA).updateChildValues([Constants.PASSWORD : Password]);
    }
    
}
