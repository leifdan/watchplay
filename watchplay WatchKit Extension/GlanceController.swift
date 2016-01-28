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
    
    override init() {
        super.init()
        
        lastUpdate.setText("Not Updated")
        currentTemp.setText("--.-\u{00B0}F")
        dailyProduction.setText("--WH")
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        self.currentTemp.setText("fetching")
        
        let myUrl = NSURL(string: "https://developer-api.nest.com/devices/thermostats/5htd8PyzrEzwp-Od0BQtp90lf9H1vqBZ?auth=c.c7XHXlqYwn3uEwzHdfHKncejLFC72POhVwFbIhmEb7ZVspPAOY3nz3nGrJlLmWyeQzN5NjTr2d9ZYNMlN6FNEDVEsksEYfDAbRL4CTRGOZmV2hwtSni4FuM0FvS8rlRAZv0yO1gyvDYgORWP")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(myUrl) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    let currentTempF = json["ambient_temperature_f"] as AnyObject? as? Int
                    self.currentTemp.setText("\(currentTempF!)\u{00B0}F")
                }
                catch {
                    self.currentTemp.setText("json error: \(error)")
                }
                self.lastUpdate.setText("Updated: " + self.getCurrentTimeString())
            }
        }
        task.resume()
        
        
        self.dailyProduction.setText("fetching")
        
        let myUrl2 = NSURL(string: "https://api.enphaseenergy.com/api/v2/systems/359168/summary?key=e5b803bbb7ec0726a4db38b811ad2c97&user_id=4d7a45304d5463790a")!
        
        let task2 = NSURLSession.sharedSession().dataTaskWithURL(myUrl2) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    let energyToday = json["energy_today"] as AnyObject? as? Int
                    self.dailyProduction.setText("\(energyToday!)")
                }
                catch {
                    self.dailyProduction.setText("json error: \(error)")
                }
                self.lastUpdate.setText("Updated: " + self.getCurrentTimeString())
            }
        }
        task2.resume()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getCurrentTimeString() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .MediumStyle
        
        return (formatter.stringFromDate(date))
    }

}
