//
//  ViewController.swift
//  WaterTracker
//
//  Created by Abhishek Birjepatil on 12/29/15.
//  Copyright © 2015 Abhishek Birjepatil. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit

//Adding CLLocationManger which will handle the part for looking and reporting the scan results
class ViewController: UIViewController, CLLocationManagerDelegate {

    //Create an Instance of the CoreLocation Class
    let locationManager = CLLocationManager() // This fellow will search for ble devices around
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    

    
    @IBOutlet var TestInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.WriteToHealthKit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ButtonClick(sender: AnyObject) {
        print(TestInput.text);
        print("test");
    }

    /*Interacts with the healthkit application on the iOS*/

    
    
    func WriteToHealthKit()
    {
        
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierStepCount)
        
        let waterIntake = HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierDietaryWater)

        
        let dataTypesToWrite = NSSet(object: waterIntake!)
        let dataTypesToRead = NSSet(object: stepsCount!)
        
        healthStore?.requestAuthorizationToShareTypes(dataTypesToWrite as! Set<HKSampleType>,
            readTypes: dataTypesToRead as! Set<HKObjectType>,
            completion: { [unowned self] (success, error) in
                if success {
                    
                    self.ActualWrite()
                    print("SUCCESS")
                } else {
                    print("ERROR")
                }
            })

    
    }
    
    
    
    func ActualWrite()
    {
        
        let stepsQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryWater)
        let stepsUnit = HKUnit.fluidOunceUSUnit()
        let stepsQuantity = HKQuantity(unit: stepsUnit,
           doubleValue: 30)
       
        let stepsQuantitySample = HKQuantitySample(
            type: stepsQuantityType!,
            quantity: stepsQuantity,
            startDate: NSDate(),
            endDate: NSDate())
        
        if let authorizationStatus = healthStore?.authorizationStatusForType(stepsQuantityType!) {
            
            switch authorizationStatus {
           
                
            case .SharingAuthorized:
                healthStore?.saveObject(stepsQuantitySample, withCompletion: { (success, error) -> Void in
                    if success {
                        // handle success
                    } else {
                        // handle error
                    }
                })
            default:
                print("Sit Idle")
            }
        }
    }
    
    
    
    }

