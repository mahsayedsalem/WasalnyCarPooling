//
//  UberHandler.swift
//  UberDriver
//
//  Created by MSA on 31/05/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol UberController: class {
    func acceptUber(Latitude: Double, Longitude: Double)
    func riderCanceledUber()
    func DriverCanceledUber()
    
}

class UberHandler {
    private static let _instance = UberHandler()
    
    weak var delegate: UberController?
    
    var rider = ""
    var driver = ""
    var driver_id = ""
    var carModel = ""
    var carType = ""
    var carColor = ""
    var Platenumber = ""
    
    
    static var Instance: UberHandler {
        return _instance
    }
    
    func observeMessagesForDriver()
    {
        //Rider Requested An Uber
        DBProvider.Instance.RequestRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let latitude = data[Constants.LATITUDE] as? Double {
                    if let longitude = data[Constants.LONGITUDE] as? Double {
                        //inform the driverVC with request
                        self.delegate?.acceptUber(Latitude: latitude, Longitude: longitude)
                    }
                }
                
                if let name = data[Constants.NAME] as? String{
                    self.rider = name
                }
            }
        }
        
        //Rider Canceled Uber
        DBProvider.Instance.RequestRef.observe(DataEventType.childRemoved){ (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary
            {
                
                if let name = data[Constants.NAME] as? String
                {
                    
                    if name == self.rider
                    {
                        //print ("here")
                        self.rider = ""
                        self.delegate?.riderCanceledUber()
                    }
                }
            }
        }
        
        //driver accepts uber
        DBProvider.Instance.RequestAccepted.observe(DataEventType.childAdded) {(snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary
            {
                if let name = data[Constants.NAME] as? String
                {
                    if name == self.driver
                    {
                        self.driver_id = snapshot.key
                    }
                }
            }
            
        }
        
        //driver canceled uber
        DBProvider.Instance.RequestAccepted.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary
            {
                if let name = data[Constants.NAME] as? String
                {
                    if name == self.driver
                    {
                        self.delegate?.DriverCanceledUber()
                    }
                }
            }
        }
        
    }
    
    func uberAccepted(Lat: Double, Long: Double)
    {
        DBProvider.Instance.DriversRef.child(DBProvider.Instance.driver_id).child(Constants.DATA).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.carColor = (value?[Constants.CAR_Color] as? String)!
            self.carModel = (value?[Constants.CAR_MODEL] as? String)!
            self.carType = (value?[Constants.CAR_TYPE] as? String)!
            self.Platenumber = (value?[Constants.PLATE_NUM] as? String)!
        
        
            let data: Dictionary<String, Any> = [Constants.NAME: self.driver, Constants.LATITUDE: Lat, Constants.LONGITUDE: Long, Constants.ARRIVED: false , Constants.CAR_TYPE: self.carType, Constants.CAR_MODEL: self.carModel, Constants.CAR_Color:self.carColor, Constants.PLATE_NUM:self.Platenumber]
        
            DBProvider.Instance.RequestAccepted.childByAutoId().setValue(data)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func cancelUberForDriver()
    {
        DBProvider.Instance.RequestAccepted.child(driver_id).removeValue()
    }
    
    func updateDriverLocation(lat: Double, Long: Double,Arrived: Bool)
    {
        DBProvider.Instance.RequestAccepted.child(driver_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGITUDE: Long,Constants.ARRIVED: Arrived])
    }
}
