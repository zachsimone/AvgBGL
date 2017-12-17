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
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Start and end dates
        let startDate = Date().startOfDay // Start of current day
        let endDate = Date() // The time now
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: .strictStartDate)
        

        let bloodGlucose = HKSampleType.quantityType(forIdentifier: .bloodGlucose)
        
        let bglQuery = HKSampleQuery.init(sampleType: bloodGlucose!,
                                             predicate: predicate,
                                             limit: HKObjectQueryNoLimit,
                                             sortDescriptors: nil,
                                             resultsHandler: { (query, results, error) in
                                                
                                                for reading in (results as? [HKQuantitySample])! {
                                                    
                                                    let mmol = HKUnit.moleUnit(with: .milli, molarMass: HKUnitMolarMassBloodGlucose)
                                                    let mmolL = mmol.unitDivided(by: HKUnit.liter())
                                                    
                                                    print("Reading as mmol/L \(reading.quantity.doubleValue(for: mmolL)) mmol/L")
                                                }
                                                
        })
        
        
        self.healthStore.execute(bglQuery)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}

