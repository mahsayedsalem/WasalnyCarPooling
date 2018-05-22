//
//  TVC.swift
//  UberRidder
//
//  Created by MSA on 12/06/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TVC: UITableViewController {
    
    
    
    @IBOutlet var tbv: UITableView!
    
    var RidestList = [Ride]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
            tbv.delegate = self
            tbv.dataSource = self
        DBProvider.Instance.RidersRef.child(DBProvider.Instance.rider_id).child(Constants.HISTORY).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            
            let count = snapshot.childrenCount
            
            if count > 0
            {
                self.RidestList.removeAll();
                
                for item in snapshot.children.allObjects as! [DataSnapshot]
                    
                {
                    
                    let valueObject = item.value as? NSDictionary
                    
                    let DateM = valueObject?[Constants.DATE] as? String
                    
                    let LocationM = valueObject?[Constants.LOCATION_NAME] as? String
                    
                    let DriverM = valueObject?[Constants.DRIVER_NAME] as? String
                    
                    let rideF = Ride(time: DateM!, location: LocationM!, DriverName: DriverM!)
                    
                    self.RidestList.append(rideF);
                }
                
                self.tbv.register(MVC.self, forCellReuseIdentifier: "cell")
                
                self.tbv.reloadData();
            }
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return RidestList.count
    }
    
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MVC
        
        
        if let ride_time = RidestList[indexPath.row].TimeX
        {
            cell.DriverX.text = ride_time
        }
        
        if let ride_location = RidestList[indexPath.row].LocationX
        {
            
            cell.TimeX.text = ride_location
        }
        
        if let river_driver = RidestList[indexPath.row].DriverNameX
        {
            
            cell.LocationX.text = river_driver
        }
        
        return cell
        }
    }
