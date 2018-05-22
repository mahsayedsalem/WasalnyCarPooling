//
//  PorfileVC.swift
//  UberRidder
//
//  Created by MSA on 11/06/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import UIKit
import SCLAlertView

class PorfileVC: UIViewController {

    @IBOutlet weak var UserNameLabel: UILabel!
    
    
    @IBOutlet weak var PhoneNumLabel: UILabel!
    
    
    @IBOutlet weak var EmailAdrLabel: UILabel!
    
    var firstname = ""
    var lastname = ""
    var email = ""
    var phone = ""
    var password = ""
    var IsRider = "True"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBProvider.Instance.RidersRef.child(DBProvider.Instance.rider_id).child(Constants.DATA).observeSingleEvent(of: .value, with: {
            (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.firstname = value?[Constants.FIRST_NAME] as! String
            self.lastname = value?[Constants.LAST_NAME] as! String
            self.email = value?[Constants.EMAIL] as! String
            self.phone = value?[Constants.PHONE_NUM] as! String
            self.password = value?[Constants.PASSWORD] as! String
            self.IsRider = value?[Constants.BANK_NUM] as! String

        
            self.UserNameLabel.text = "\(self.firstname) \(self.lastname)"
            self.PhoneNumLabel.text = "\(self.phone)"
            self.EmailAdrLabel.text = "\(self.email)"
        })
    }

    
    
    @IBAction func ChangePassword(_ sender: Any) {
        
        self.resetPassAlert();
    }

    @IBAction func SignoutButton(_ sender: Any) {
        
        if AuthProvider.Instance.Logout()
        {
            dismiss(animated: true, completion: nil)
        }
        else
        {
            SCLAlertView().showError("Error", subTitle: "Can't logout! Try again later.")
        }
    }
    
    
    private func resetPassAlert(){
        let alert = SCLAlertView()
        
        let txt = alert.addTextField()
        txt.placeholder = "Old Password"
        txt.isSecureTextEntry = true
        txt.autocorrectionType = .no
        
        let txt2 = alert.addTextField()
        txt2.placeholder = "New Password"
        txt2.isSecureTextEntry = true
        txt2.autocorrectionType = .no
        
        let txt3 = alert.addTextField()
        txt3.placeholder = "Confirm Password"
        txt3.isSecureTextEntry = true
        txt3.autocorrectionType = .no
        
        
        alert.addButton("Change Password")
        {
            if txt.text != "" && txt2.text != "" && txt3.text != ""
            {
                if txt.text == self.password && txt2.text == txt3.text
                {
                    let result = AuthProvider.Instance.ChangePass(Password: txt2.text!)
                    if result == "Yes"
                    {
                        SCLAlertView().showSuccess("Status", subTitle: "Password Changed!")
                        DBProvider.Instance.UpdatePassword(Password: txt2.text!);
                        self.password = txt2.text!;
                    }
                }
                
            }
            else
            {
                
                SCLAlertView().showError("Problem Occured", subTitle: "You entered the wrong data")
            }
        }
        alert.showEdit(
            "Change your password",
            subTitle: "Insert the following data",
            closeButtonTitle: "Cancel"
        )
        
    }
    
   

}
