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

    // UI average labels
    @IBOutlet weak var mostRecentBGL: UILabel!
    @IBOutlet weak var avgToday: UILabel!
    @IBOutlet weak var avgSevenDays: UILabel!
    @IBOutlet weak var avgThreeMonths: UILabel!
    
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
        
        // Declare dates
        let now = Date()
        let startOfDay = now.startOfDay
        let sevenDaysAgo = Date(timeIntervalSinceNow: -60*60*24*7) // 60 seconds * 60 mins * 24 hours * 7 days
        let threeMonthsAgo = Date(timeIntervalSinceNow: -60*60*24*90) // Time 90 days (~3 months) ago
        
        // Average today
        fetchData(startDate: startOfDay, endDate: now) { (data) -> Void in
            DispatchQueue.main.async(execute: {
                self.avgToday.text = "\(self.average(values: data)) mmol/L"
            })
        }
        
        // 7-day average
        fetchData(startDate: sevenDaysAgo, endDate: now) { (data) -> Void in
            DispatchQueue.main.async(execute: {
                self.avgSevenDays.text = "\(self.average(values: data)) mmol/L"
            })
        }
        
        // 90-day average
        fetchData(startDate: threeMonthsAgo, endDate: now) { (data) -> Void in
            DispatchQueue.main.async(execute: {
                self.avgThreeMonths.text = "\(self.average(values: data)) mmol/L"
            })
        }
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

