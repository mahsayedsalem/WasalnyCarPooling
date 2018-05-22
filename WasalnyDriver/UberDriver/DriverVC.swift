//
//  DriverVC.swift
//  UberDriver
//
//  Created by MSA on 28/05/2017.
//  Copyright © 2017 MSA. All rights reserved.
//

import UIKit
import MapKit

class DriverVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UberController {
    
    @IBOutlet weak var DistanceL: UILabel!
    @IBOutlet weak var MyMap: MKMapView!
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var pickUpLocation: CLLocationCoordinate2D?
    
    private var timer = Timer()
    
    @IBOutlet weak var CancelUberBTN: UIButton!
    
    @IBOutlet weak var ArrivedBtn: UIButton!
    
    private var acceptedUber = false
    private var driverCanceledUber = false
    
    private var arrived = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitializeLocationManager()
        UberHandler.Instance.delegate = self
        UberHandler.Instance.observeMessagesForDriver()
        
        MyMap .showsUserLocation = true;
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
            
            Annotation.title = "Drivers Location"
            
            //MyMap.addAnnotation(Annotation)
            
            if(pickUpLocation != nil)
            {
                if acceptedUber
                {
                    let ridderAnnotation = MKPointAnnotation()
                    ridderAnnotation.coordinate = pickUpLocation!
                    ridderAnnotation.title = "Pick Up Location"
                    MyMap.addAnnotation(ridderAnnotation)
                    
                    // draw route
                    
                    let sourcePlaceMark = MKPlacemark(coordinate: userLocation!)
                    let destinationPlaceMark = MKPlacemark(coordinate: pickUpLocation!)
                    
                    let sourceItem = MKMapItem(placemark: sourcePlaceMark)
                    let destItem = MKMapItem(placemark: destinationPlaceMark)
                    
                    let request = MKDirectionsRequest()
                    request.source = sourceItem
                    request.destination = destItem
                    request.transportType = .automobile
                    
                    let directions = MKDirections(request: request)
                    
                    directions.calculate(completionHandler: { (response, error) in
                        
                        if error != nil
                        {
                            print ("something Went Wrong")
                            self.DistanceL.isHidden = true
                        }
                        else
                        {
                            let route = response?.routes[0]
                            self.MyMap.add((route?.polyline)!, level: .aboveRoads)
                            
                            let seconds = route?.expectedTravelTime
                            
                            self.DistanceL.text = "Seconds Left: \(seconds)"
                            self.DistanceL.isHidden = false
                            
                            
                        }
                    })
                }
                else
                {
                    self.DistanceL.isHidden = true
                }
            }
            else
            {
                self.DistanceL.isHidden = true
            }

        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    
    @IBAction func LogoutB(_ sender: Any) {
        if AuthProvider.Instance.Logout()
        {
            if(acceptedUber)
            {
                CancelUberBTN.isHidden = true
                self.ArrivedBtn.isHidden = true
                UberHandler.Instance.cancelUberForDriver()
                timer.invalidate()
            }
            dismiss(animated: true, completion: nil)
        }
        else
        {
            //Problem With Loging Out
            UberRequest(title: "Could Not Logout", Message: "Can Not Logout At The Moment, Please Try Again Later", requestAlive: false,Lat: (userLocation?.latitude)!,Long: (userLocation?.longitude)!)
        }
    }
    
    func acceptUber(Latitude: Double, Longitude: Double) {
        if !acceptedUber
        {
            UberRequest(title: "Uber Request", Message: "You Have an Uber Request At this Location Lat: \(Latitude), Long: \(Longitude)", requestAlive: true, Lat:Latitude, Long: Longitude)
        }
    }
    
    func riderCanceledUber() {
        if !driverCanceledUber {
            if !arrived
            {
                UberHandler.Instance.cancelUberForDriver()
                self.timer.invalidate()
                self.acceptedUber = false
                self.CancelUberBTN.isHidden = true
                self.ArrivedBtn.isHidden = true
                UberRequest(title: "Uber Canceled", Message: "The Rider Has Canceled The Uber Request", requestAlive: false,Lat: (userLocation?.latitude)!,Long:(userLocation?.longitude)!)
            }
        }
    }
    
    func DriverCanceledUber() {
        acceptedUber = false
        CancelUberBTN.isHidden = true
        self.ArrivedBtn.isHidden = true
        //invalidate timer
        timer.invalidate()
    }
    
    func updateDriverLocation()
    {
        UberHandler.Instance.updateDriverLocation(lat: (userLocation?.latitude)!, Long: (userLocation?.longitude)!,Arrived: false)
    }
    
    @IBAction func ArrivedB(_ sender: Any) {
        arrived = true
        UberHandler.Instance.updateDriverLocation(lat: (userLocation?.latitude)!, Long: (userLocation?.longitude)!,Arrived: true)
        UberHandler.Instance.cancelUberForDriver()
    }
    @IBAction func CancelUberB(_ sender: Any) {
        if acceptedUber{
            driverCanceledUber = true
            CancelUberBTN.isHidden = true
            ArrivedBtn.isHidden = true
            UberHandler.Instance.cancelUberForDriver()
            
            //invalidate timer (updates location of driver & rider)
            timer.invalidate()
        }
    }
    
    private func UberRequest(title: String, Message: String, requestAlive: Bool, Lat: Double, Long: Double){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        
        if requestAlive
        {
            let accept = UIAlertAction(title: "Accept", style: .default, handler: { (UIAlertAction) in
                self.acceptedUber = true
                self.arrived = false
                self.CancelUberBTN.isHidden = false
                self.ArrivedBtn.isHidden = false
                
                //save pickup location
                self.pickUpLocation = CLLocationCoordinate2D(latitude: Lat, longitude: Long)
                
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(DriverVC.updateDriverLocation), userInfo: nil, repeats: true)
                
                UberHandler.Instance.uberAccepted(Lat: Double(self.userLocation!.latitude), Long: Double(self.userLocation!.longitude))
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            
            alert.addAction(accept)
            alert.addAction(cancel)
        }else
        {
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
        }
        
        present(alert, animated: true, completion: nil)
    }
}
