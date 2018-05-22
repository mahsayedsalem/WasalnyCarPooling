//
//  UberHandler.swift
//  UberRidder
//
//  Created by MSA on 31/05/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol UberContoller: class {
    func canCallUber(delegateCalled: Bool)
    func driverAccepted(requestAccepted: Bool, DriverName: String, Arrived: Bool,carType: String, CarModel: String, CarColor: String, plateNum: String)
    func updateDriverLocation(lat:Double, long:Double)
}

class UberHandler {
    private static let _instance = UberHandler()
    
    weak var delegate: UberContoller?
    
    var rider = ""
    var driver = ""
    var rider_id = ""
    
    static var Instance: UberHandler {
        return _instance
    }
    
    func observeMessagesForRider()
    {
        //Rider Requested Uber
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            if let date = snapshot.value as? NSDictionary
            {
                if let name = date[Constants.NAME] as? String
                {
                    if name == self.rider
                    {
                        self.rider_id = snapshot.key
                        self.delegate?.canCallUber(delegateCalled: true)
                    }
                }
            }
        }
        
        //Rider Canceled Uber
        DBProvider.Instance.requestRef.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            if let date = snapshot.value as? NSDictionary
            {
                if let name = date[Constants.NAME] as? String
                {
                    if name == self.rider
                    {
                        self.delegate?.canCallUber(delegateCalled: false)
                    }
                }
            }
        }
        
        //Driver Accepted
        DBProvider.Instance.RequestAccepted.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary
            {
                if let name = data[Constants.NAME] as? String
                {
                    if self.driver == ""
                    {
                        let carType = data[Constants.CAR_TYPE] as? String
                        let carModel = data[Constants.CAR_MODEL] as? String
                        let CarColor = data[Constants.CAR_Color] as? String
                        let plateNumber = data[Constants.PLATE_NUM] as? String
                    
                        self.driver = name
                        
                        self.delegate?.driverAccepted(requestAccepted: true, DriverName: self.driver, Arrived: false,carType: carType!, CarModel: carModel!, CarColor: CarColor!, plateNum: plateNumber!)
                    }
                }
            }
        }
        
        //Driver Canceled
        DBProvider.Instance.RequestAccepted.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary
            {
                if let name = data[Constants.NAME] as? String
                {
                    if name == self.driver
                    {
                        if let arrived = data[Constants.ARRIVED] as? Bool
                        {
                           if arrived
                           {
                                self.delegate?.driverAccepted(requestAccepted: false, DriverName: name, Arrived: true,carType: "", CarModel: "", CarColor: "", plateNum:"")
                           }
                           else
                           {
                                self.delegate?.driverAccepted(requestAccepted: false, DriverName: name, Arrived: false,carType: "", CarModel: "", CarColor: "", plateNum:"")
                            }
                        }
                        self.driver = ""
                    }
                }
            }
        }
        
        //updating driver location
        DBProvider.Instance.RequestAccepted.observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary
            {
                if let name = data[Constants.NAME] as? String
                {
                    if name == self.driver
                    {
                        if let lat = data[Constants.LATITUDE] as? Double
                        {
                            if let long = data[Constants.LONGITUDE] as? Double
                            {
                                self.delegate?.updateDriverLocation(lat: lat, long: long)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func requestUber(latitude: Double, longitude: Double) {
        
        let data: Dictionary<String, Any> = [Constants.NAME: rider,Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude]
        
        DBProvider.Instance.requestRef.childByAutoId().setValue(data)
    }//request Uber
    
    func cancelUber()
    {
        DBProvider.Instance.requestRef.child(rider_id).removeValue()
    }
    
    func AddToHistory(latitude: Double, longitude: Double, Name: NSString){
        
        DBProvider.Instance.RidersRef.child(DBProvider.Instance.rider_id).child(Constants.DATA).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var count = value?[Constants.RIDES_COUNT] as? Int
            
            count = count! + 1
            
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let convertedDate = dateFormatter.string(from: currentDate)
            
            
            let data: Dictionary<String, Any> = [Constants.NAME: self.rider,Constants.LOCATION_NAME: Name, Constants.DATE: convertedDate, Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude,Constants.DRIVER_NAME: self.driver]
            
            DBProvider.Instance.AddToHistory.child("\(count!)").setValue(data)
            
            DBProvider.Instance.RidersRef.child(DBProvider.Instance.rider_id).child(Constants.DATA).updateChildValues([Constants.RIDES_COUNT: count!])
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}
