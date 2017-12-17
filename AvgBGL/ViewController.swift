//
//  ViewController.swift
//  AvgBGL
//
//  Created by Zachary Simone on 17/12/17.
//  Copyright © 2017 Zachary Simone. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    var healthStore: HKHealthStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Check health data is available
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            
            let shareTypes = Set<HKSampleType>()
            
            var readTypes = Set<HKObjectType>()
            readTypes.insert(HKSampleType.quantityType(forIdentifier: .bloodGlucose)!)
            
            healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) -> Void in
                if success {
                    print("success")
                } else {
                    print("failure")
                }
                
                if let error = error { print(error) }
            }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

