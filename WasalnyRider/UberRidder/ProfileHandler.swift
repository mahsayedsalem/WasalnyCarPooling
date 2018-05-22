//
//  ProfileHandler.swift
//  UberRidder
//
//  Created by MSA on 12/06/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ProfileHandler{

    private static let _instance = ProfileHandler()
    
    static var Instance: ProfileHandler{
        return _instance
    }
    
    var firstname = ""
    var lastname = ""
    var email = ""
    var phone = ""
    var password = ""
    var IsRider = "True"
    
    var Rider_Email = "";

    func GrabUserData() -> (String, String, String, String, String)
    {
        DBProvider.Instance.RidersRef.child(DBProvider.Instance.rider_id).child(Constants.DATA).observeSingleEvent(of: .value, with: {
            (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.firstname = value?[Constants.FIRST_NAME] as! String
            self.lastname = value?[Constants.LAST_NAME] as! String
            self.email = value?[Constants.EMAIL] as! String
            self.phone = value?[Constants.PHONE_NUM] as! String
            self.password = value?[Constants.PASSWORD] as! String
            self.IsRider = value?[Constants.BANK_NUM] as! String
        })
        
        return (firstname, lastname, email, phone, password);
        
    }


}
