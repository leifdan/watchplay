//
//  GlanceController.swift
//  watchplay WatchKit Extension
//
//  Created by Leif Danielson on 1/21/16.
//  Copyright © 2016 SEP. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {
    
    @IBOutlet var currentTemp: WKInterfaceLabel!
    @IBOutlet var dailyProduction: WKInterfaceLabel!
    @IBOutlet var lastUpdate: WKInterfaceLabel!
    
    var houseData = HouseData()
    
    override init() {
        super.init()
        
        refreshScreen()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        houseData.updateData(refreshScreen)
    }
    
    func refreshScreen() {
        self.dailyProduction.setText(formatProduction(houseData.todaysProductionWH))
        self.currentTemp.setText(formatTemp(houseData.currentTempF))
        self.lastUpdate.setText(formatUpdateTime(houseData.lastUpdate))
        
    }
    
    func formatTemp(temp: Double?) -> String {
        if (temp != nil) {
            return "\(temp!)\u{00B0}F"
        }
        else {
            return "--.-\u{00B0}F"
        }
    }
    
    func formatProduction(generated: Int?) -> String {
        if (generated != nil) {
            if (generated < 1000) {
                return "\(generated!)WH"
            }
            else {
                return "\(generated!/1000)kWh"
            }
        }
        else {
            return "--WH"
        }
    }
    
    func formatUpdateTime(time: NSDate?) -> String {
        if (time != nil) {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .MediumStyle
            
            return ("Updated Last: \n" + formatter.stringFromDate(time!))
        }
        else {
            return "Not Updated"
        }
    }
}


