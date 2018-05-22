//
//  RiderVC.swift
//  UberRidder
//
//  Created by MSA on 28/05/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UberContoller{

    @IBOutlet weak var leadingConst: NSLayoutConstraint!
    @IBOutlet weak var CallUberBTN: UIButton!
    @IBOutlet weak var MyMap: MKMapView!
    
    
    @IBOutlet weak var MenuView: UIView!
    var MenuBool = false;
    
    
    @IBAction func ShowMap(_ sender: Any) {
        
        if (MenuBool)
        {
            leadingConst.constant = -136;
            //MenuView.backgroundColor = UIColor.clear;
        }
        else
        {
            leadingConst.constant = 0;
            //MenuView.backgroundColor = UIColor(red:0.15, green:0.83, blue:0.82, alpha:1.0);
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded();
            })
            
        }
        
        MenuBool = !MenuBool;
    }
   
    /*@IBAction func LogoutAction(_ sender: Any) {
        
        if AuthProvider.Instance.Logout()
        {
            if(!canCallUber)
            {
                UberHandler.Instance.cancelUber()
            }
            dismiss(animated: true, completion: nil)
        }
        else
        {
            alertUser(title: "Error!", Message: "Can't logout! Try again later.",cancel: true)
            
        }
        
    }*/
    
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var DriverLocation: CLLocationCoordinate2D?
    private var PickupLocation: CLLocationCoordinate2D?
    private var PickupLocationName: NSString = ""
    
    
    private var canCallUber = true
    private var riderCanceledRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitializeLocationManager()
        UberHandler.Instance.delegate = self
        UberHandler.Instance.observeMessagesForRider()
        
        MyMap.showsUserLocation = true
    }
    
    private func InitializeLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // if we have the co-ordinates from  manager
        if let location = locationManager.location?.coordinate{
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            //span is zooming level
            
            MyMap.setRegion(region, animated: true)
            
            
            MyMap.removeAnnotations(MyMap.annotations)
            
            
            
            let Annotation = MKPointAnnotation()
            Annotation.coordinate = userLocation!
            
            Annotation.title = "Pick Up Location"
            
            //MyMap.addAnnotation(Annotation)
            
            if DriverLocation != nil
            {
                if !canCallUber
                {
                    let driverAnnotation = MKPointAnnotation()
                    driverAnnotation.coordinate = DriverLocation!
                    driverAnnotation.title = "Driver's Location"
                    MyMap.addAnnotation(driverAnnotation)
                }
            }
            
        }
    }
    
   
    
    func canCallUber(delegateCalled: Bool) {
        if delegateCalled
        {
            CallUberBTN.setTitle("Cancel Tawseela", for: .normal)
            canCallUber = false
        }
            
        else
        {
            CallUberBTN.setTitle("Wasalny", for: .normal)
            canCallUber = true
        }
    }
    
    func driverAccepted(requestAccepted: Bool, DriverName: String, Arrived: Bool, carType: String, CarModel: String, CarColor: String, plateNum: String) {
        if !riderCanceledRequest{
            if requestAccepted{
                alertUser(title: "You've Tawseela!", Message: "\(DriverName) accepted your Wasalny and on his way! \(carType) \(CarModel) \(CarColor) \(plateNum)",cancel: false)
            }
            else
            {
                if !Arrived
                {
                    UberHandler.Instance.cancelUber()
                    alertUser(title: "Wasalny Canceled", Message: "The Driver Canceled Wasalny Request",cancel: true)
                }
                else
                {
                    UberHandler.Instance.cancelUber()
                    alertUser(title: "Wasalny Arrived", Message: "Your Tawseela is here!",cancel: true)
                }
            }
        }
        
        riderCanceledRequest = false
    }
    
    func updateDriverLocation(lat: Double, long: Double) {
        DriverLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    @IBAction func CallUberB(_ sender: Any) {
        
        if userLocation != nil{
            if canCallUber
            {
                UberHandler.Instance.requestUber(latitude: Double(userLocation!.latitude), longitude: Double(userLocation!.longitude))
                PickupLocation = CLLocationCoordinate2D(latitude: userLocation!.latitude, longitude: userLocation!.longitude)
                let location = CLLocation(latitude: PickupLocation!.latitude, longitude: PickupLocation!.longitude)
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location, completionHandler: { (PlaceMarks, error) in
                    
                    var placeMark: CLPlacemark!
                    placeMark = PlaceMarks?[0]
                    
                    if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                        //print("Name: \(locationName)")
                        self.PickupLocationName = locationName
                    }
                    
                })
            }
            else{
                riderCanceledRequest = true
                UberHandler.Instance.cancelUber()
            }
        }
    }
    
    private func alertUser (title: String, Message: String, cancel: Bool)
    {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            
            if(!cancel)
            {
                if self.PickupLocation != nil
                {
                    //let PlaceMark = MKPlacemark(coordinate: self.PickupLocation!)
                    //let name = PlaceMark.name
                
                    UberHandler.Instance.AddToHistory(latitude:self.PickupLocation!.latitude, longitude: self.PickupLocation!.longitude, Name: self.PickupLocationName)
                }
            }
        }
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }

}
