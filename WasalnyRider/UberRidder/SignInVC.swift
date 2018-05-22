//
//  SignInVCViewController.swift
//  UberRidder
//
//  Created by MSA on 26/05/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import UIKit
import SCLAlertView


class SignInVC: UIViewController {
    
    private let RIDER_SEGUE = "RiderVC"
    
    var FN = "";
    var LN = "";
    var PN = "";
    var SUEmail = "";
    var SUPassword = "";
    var CN = "NA";
    
    @IBOutlet weak var EmailTF: UITextField!
    
    @IBOutlet weak var PasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func resetPassword(_ sender: Any) {
        self.resetPassAlert();
    }

 
    
    @IBAction func LoginB(_ sender: Any) {
        if EmailTF.text != "" && PasswordTF.text != ""
        {
            AuthProvider.Instance.Login(Email: EmailTF.text!, Password: PasswordTF.text!, loginHandler: { (message) in
                
                if message != nil
                {
                    SCLAlertView().showError("Problem with login", subTitle: message!)
                }
                else
                {
                    //print("login Completed")
                
                    UberHandler.Instance.rider = self.EmailTF.text!
                    ProfileHandler.Instance.Rider_Email = self.EmailTF.text!;
                    self.EmailTF.text = ""
                    self.PasswordTF.text = ""
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil)
                }
            })
        }
        else
        {
            SCLAlertView().showError("Error", subTitle: "Please enter username and password")
        }
    }
    
    @IBAction func SignupB(_ sender: Any)
    {
        self.signUpAlertFunc();
        
           }
    
    
    
    private func alertUser (title: String, Message: String)
    {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    private func resetPassAlert(){
        let alert = SCLAlertView()
        
        let txt = alert.addTextField()
        txt.placeholder = "Email"
        txt.keyboardType = UIKeyboardType.emailAddress
        txt.autocorrectionType = .no
        
        
        alert.addButton("Send the email")
        {
            if txt.text != ""
            {
                AuthProvider.Instance.ResetPassword(withEmail: (txt.text)!, loginHandler: { (message) in
                    
                    if message != nil
                    {
                        SCLAlertView().showError("Problem with restarting email", subTitle: message!)
                    }
                    else
                    {
                        //print("login Completed")
                        
                        SCLAlertView().showSuccess("Status", subTitle: "Email sent!")
                    }
                })
            }
            else
            {
                
                SCLAlertView().showError("Problem Occured", subTitle: "You must enter your email address in order to send  you the recovery email")
                            }
        }
        alert.showEdit(
            "Recover your password",
            subTitle: "Insert your email and you will recieve an email with the recovery process",
            closeButtonTitle: "Cancel"
        )

    }
    
    private func signUpAlertFunc ()
    {
        let alert = SCLAlertView()
        let txt1 = alert.addTextField()
        txt1.placeholder = "First Name"
        txt1.autocorrectionType = .no
        
        let txt2 = alert.addTextField()
        txt2.placeholder = "Second Name"
        txt2.autocorrectionType = .no
        
        let txt3 = alert.addTextField()
        txt3.placeholder = "Phone Number"
        txt3.autocorrectionType = .no
        
        let txt4 = alert.addTextField()
        txt4.placeholder = "Email"
        txt4.keyboardType = UIKeyboardType.emailAddress
        txt4.autocorrectionType = .no
        
        
        let txt5 = alert.addTextField()
        txt5.placeholder = "Password"
        txt5.isSecureTextEntry=true
        txt5.autocorrectionType = .no
        
        let txt6 = alert.addTextField()
        txt6.placeholder = "Credit Card Number (Optional)"
        txt6.isSecureTextEntry=true
        txt6.autocorrectionType = .no
        
        
        
        alert.addButton("Signup") {
            
            self.FN = txt1.text!
                self.LN = txt2.text!
                self.PN = txt3.text!
                self.SUEmail = txt4.text!
                self.SUPassword = txt5.text!
                self.CN = txt6.text!
            
                if self.FN != "" && self.LN != "" && self.SUEmail != "" && self.SUPassword != "" && self.PN != ""
                {
                    AuthProvider.Instance.Signup(Fname: self.FN, Lname: self.LN, PhoneNumber: self.PN, Email: self.SUEmail, Password: self.SUPassword, BankNum: self.CN, loginHandler: { (message) in
                        
                        if message != nil {
                            
                            SCLAlertView().showError("Problem with creating new user", subTitle: message!)
                            
                            
                        }
                        else{
                            UberHandler.Instance.rider = self.SUEmail;
                            ProfileHandler.Instance.Rider_Email = self.SUEmail;
                            self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil)                }
                    });
                }
                else
                {
                    
                    SCLAlertView().showError("You Info is required", subTitle: "Please Enter All The Information")
            }
            
        }
        alert.showEdit(
            "Signup",
            subTitle: "Insert your information and join Wasalny Community!",
            closeButtonTitle: "Cancel"
        )

    }
}
