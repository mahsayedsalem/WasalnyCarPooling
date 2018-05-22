//
//  AuthProvider.swift
//  UberRidder
//
//  Created by MSA on 26/05/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode {
    static let  INVALID_EMAIL = "Invalid Email Address, Please Provide A Real Email Address"
    static let WRONG_PASSWORD = "Wrong Password, Please Enter The Correct Password"
    static let USER_NOT_FOUND = "User Not Found, Please Register"
    static let  PROBLEM_CONNECTING = "Problem Connecting TO Database"
    static let EMAIL_ALREADY_IN_USE = "Email Already In Use, Please Use Another Email"
    static let WEAK_PASSWORD = "Password Should Be Atleast 6 Characters Long"
}

class AuthProvider{
    private static let _instance = AuthProvider()
    
    static var Instance: AuthProvider
    {
        return _instance
    }
    
    func Login(Email: String, Password: String, loginHandler: LoginHandler?){
        Auth.auth().signIn(withEmail: Email, password: Password) { (user, error) in
            
            if error != nil{
                self.ErrorHandler(err: error!as NSError, loginHandler: loginHandler)
            }
            else
            {
                DBProvider.Instance.driver_id = (user?.uid)!
                loginHandler?(nil)
            }
        }
    }
    
    
    
    
    func ResetPassword(withEmail: String, loginHandler: LoginHandler?)
    {
        
        Auth.auth().sendPasswordReset(withEmail: withEmail) { (error) in
            if error != nil{
                self.ErrorHandler(err: error!as NSError, loginHandler: loginHandler)
            }
            else
            {
                loginHandler?(nil)
            }
        }
    }
    
    
    
    
    
    func Signup(Fname: String, Lname: String, PhoneNumber: String, Email: String, Password: String, BankNum: String, CarType: String, CarColor: String, CarModel: String, PlateNumber: String, loginHandler: LoginHandler?)
    {
        Auth.auth().createUser(withEmail: Email, password: Password) { (user, error) in
            if error != nil{
                self.ErrorHandler(err: error!as NSError, loginHandler: loginHandler)
            }
            else
            {
                if user?.uid != nil
                {
                    DBProvider.Instance.driver_id = (user?.uid)!
                    
                    //store user to database
                    DBProvider.Instance.SaveUser(Fname: Fname, Lname: Lname, PNumber: PhoneNumber, ID: (user?.uid)!, Email: Email, Password: Password, CCN: BankNum, CarType: CarType, CarColor: CarColor, CarModel: CarModel, PlateNumber: PlateNumber)
                    
                    self.Login(Email: Email, Password: Password, loginHandler: loginHandler)
                }
            }
        }
    }
    
    
    func Logout() -> Bool
    {
        if Auth.auth().currentUser != nil
        {
            do{
                try Auth.auth().signOut()
                return true
            }catch{
                return false
            }
        }
        
        return true
    }
    
    private func ErrorHandler (err: NSError,loginHandler: LoginHandler?)
    {
        if let errCode = AuthErrorCode(rawValue: err.code)
        {
            switch errCode {
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
                
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
                
            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
                
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break
                
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
                
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
                break
            }
        }
    }
}
