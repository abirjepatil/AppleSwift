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
import CoreBluetooth

//Adding CLLocationManger which will handle the part for looking and reporting the scan results
class ViewController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate {
    var connectingPeripheral:CBPeripheral!
    //Create an Instance of the CoreLocation Class
    let locationManager = CLLocationManager() // This fellow will search for ble devices around
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    var centralManager:CBCentralManager!
    var blueToothReady = false

    
    @IBOutlet var TestInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.WriteToHealthKit()
        startUpCentralManager()
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
    
    
    
    func startUpCentralManager() {
        print("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func discoverDevices() {
        print("discovering devices")
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {

        if peripheral.name == "WICED Proximity"
        {
        print("Discovered \(peripheral.name) \(peripheral.identifier) ")
        self.centralManager.connectPeripheral(peripheral, options: nil)
             self.connectingPeripheral = peripheral
            centralManager.stopScan()
        }
    }
    
    
    func centralManager(central: CBCentralManager!,didConnectPeripheral peripheral: CBPeripheral!)
    {
    //    connectingPeripheral.discoverServices(nil)
        peripheral.discoverServices(nil)
        print("Connected")
        
     
    }
    
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        print("checking state")
        switch (central.state) {
        case .PoweredOff:
            print("CoreBluetooth BLE hardware is powered off")
            
        case .PoweredOn:
            print("CoreBluetooth BLE hardware is powered on and ready")
            blueToothReady = true;
            
        case .Resetting:
            print("CoreBluetooth BLE hardware is resetting")
            
        case .Unauthorized:
            print("CoreBluetooth BLE state is unauthorized")
            
        case .Unknown:
            print("CoreBluetooth BLE state is unknown");
            
        case .Unsupported:
            print("CoreBluetooth BLE hardware is unsupported on this platform");
            
        }
        if blueToothReady {
            discoverDevices()
        }
    }
    
    }

