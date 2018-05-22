//
//  TableViewController.swift
//  UberRidder
//
//  Created by MSA on 12/06/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TableViewController: UITableViewController {
    
    
    var RidestList = [Ride]()
    @IBOutlet var tableviewRides: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        
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
                
                self.tableviewRides.reloadData();
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        
        let ride_time = RidestList[indexPath.row].TimeX
        let ride_location = RidestList[indexPath.row].LocationX
        let river_driver = RidestList[indexPath.row].DriverNameX
        
        
        cell.TimeM.text = ride_time
        cell.PlaceM.text = ride_location
        cell.DriverM.text = river_driver
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
