//
//  ViewController.swift
//  WaterTracker
//
//  Created by Abhishek Birjepatil on 12/29/15.
//  Copyright © 2015 Abhishek Birjepatil. All rights reserved.
//

import UIKit
import CoreLocation

//Adding CLLocationManger which will handle the part for looking and reporting the scan results
class ViewController: UIViewController, CLLocationManagerDelegate {

    
    //Create an Instance of the CoreLocation Class
    let locationManager = CLLocationManager() // This fellow will search for ble devices around
    
    
    @IBOutlet var TestInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //After Scanning the results should be available here
        locationManager.delegate=self;// Similar to a call back
        //requires user permission
        locationManager.requestWhenInUseAuthorization()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ButtonClick(sender: AnyObject) {
        print(TestInput.text);
        print("test");
    }

}

