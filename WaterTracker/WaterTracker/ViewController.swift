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
class ViewController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    var sensorTagPeripheral : CBPeripheral!
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
        
         print("Discovered \(peripheral.name) \(peripheral.identifier) ")

        if peripheral.name == "BLE HR Monitor"
        {
        print("Discovered \(peripheral.name) \(peripheral.identifier) ")
        /*
            self.centralManager.connectPeripheral(peripheral, options: nil)
             self.connectingPeripheral = peripheral
            centralManager.stopScan()
        */
            // Stop scanning
            self.centralManager.stopScan()
            // Set as the peripheral to use and establish connection
            self.sensorTagPeripheral = peripheral
            self.sensorTagPeripheral.delegate = self
            self.centralManager.connectPeripheral(peripheral, options: nil)
        
        
        }
    }
    
    
    func centralManager(central: CBCentralManager!,didConnectPeripheral peripheral: CBPeripheral!)
    {
    //    connectingPeripheral.discoverServices(nil)
        peripheral.discoverServices(nil)
        print("Connected")
    }
    
    
    // Check if the service discovered is a valid IR Temperature Service
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        print("Looking at peripheral services")
        for service in peripheral.services! {
            let thisService = service as CBService
         //  if service.UUID == 1803 {
                // Discover characteristics of IR Temperature Service
                peripheral.discoverCharacteristics(nil, forService: thisService)
            
           // }
           //  Uncomment to print list of UUIDs
            print(thisService.UUID)
        }
    }
    
    
    // Enable notification and sensor for each characteristic of valid service
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
        // update status label
        print( "Enabling sensors")
        
        // 0x01 data byte to enable sensor
        var enableValue = 1
        let enablyBytes = NSData(bytes: &enableValue, length: sizeof(UInt8))
        
        // check the uuid of each characteristic to find config and data characteristics
        for charateristic in service.characteristics! {
            
            let thisCharacteristic = charateristic as CBCharacteristic
            // check for data characteristic
           // if thisCharacteristic.UUID == IRTemperatureDataUUID {
                // Enable Sensor Notification
                sensorTagPeripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
            //}
            // check for config characteristic
           // if thisCharacteristic.UUID == IRTemperatureConfigUUID {
                // Enable Sensor
                //self.sensorTagPeripheral.writeValue(enablyBytes, forCharacteristic: thisCharacteristic, type: CBCharacteristicWriteType.WithResponse)
            //}
        }
        
    }

    
    // Get data values when they are updated
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
       print( "Connected")
        
      //  if characteristic.UUID == IRTemperatureDataUUID {
            // Convert NSData to array of signed 16 bit values
            let dataBytes = characteristic.value
            let dataLength = dataBytes!.length
            var dataArray = [Int16](count: dataLength, repeatedValue: 0)
            dataBytes!.getBytes(&dataArray, length: dataLength * sizeof(Int16))
        
        
        
            // Element 1 of the array will be ambient temperature raw value
            let ambientTemperature = Double(dataArray[0])/128
        
        
            // Display on the temp label
            print(ambientTemperature)
        //self.tempLabel.text = NSString(format: "%.2f", ambientTemperature)
      //  }
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

