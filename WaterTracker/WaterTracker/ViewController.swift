//
//  ViewController.swift
//  WaterTracker
//
//  Created by Abhishek Birjepatil on 12/29/15.
//  Copyright © 2015 Abhishek Birjepatil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var TestInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

