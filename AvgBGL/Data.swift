//
//  Data.swift
//  AvgBGL
//
//  Created by Zachary Simone on 20/12/17.
//  Copyright © 2017 Zachary Simone. All rights reserved.
//

import Foundation
import HealthKit

extension ViewController {
    
    
    // This function fetches the health data, and returns the average over the specified time period
    func fetchData(startDate: Date, endDate: Date, completion: @escaping (_ data: [Double]) -> ()) {
        
        var data = [Double]() // The array of data to be returned
        
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
                                                
                                                // Append to data array
                                                data.append(reading.quantity.doubleValue(for: mmolL))
                                                
                                            }
                                            
                                            completion(data)
                                            
        })
        
        healthStore.execute(bglQuery)
    
    }
    
    func average(values: [Double]) -> Double {
        let sum = values.reduce(0, {$0 + $1})
        let average = Double(sum) / Double(values.count)
        return average.roundToDecimal(2) // Round to 2 decimal places
    }
}
