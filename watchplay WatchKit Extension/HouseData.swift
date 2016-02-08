//
//  HouseData.swift
//  watchplay
//
//  Created by Themen Danielson on 1/29/16.
//  Copyright © 2016 SEP. All rights reserved.
//

import Foundation

class HouseData {
    
    private var updateIntervalMinutes : NSTimeInterval = 10 * 60
    var lastUpdate : NSDate? = nil
    var currentTempF : Double?
    var todaysProductionWH : Int?
    
    init() {
        
        updateData(){}
    }
    
    func updateData(refresh : () -> Void) {
        if (lastUpdate != nil) {
            if (NSDate().timeIntervalSinceDate(lastUpdate!) < updateIntervalMinutes) {
                return
            }
        }
        
        
        let myUrl = NSURL(string: "https://developer-api.nest.com/devices/thermostats/5htd8PyzrEzwp-Od0BQtp90lf9H1vqBZ?auth=c.c7XHXlqYwn3uEwzHdfHKncejLFC72POhVwFbIhmEb7ZVspPAOY3nz3nGrJlLmWyeQzN5NjTr2d9ZYNMlN6FNEDVEsksEYfDAbRL4CTRGOZmV2hwtSni4FuM0FvS8rlRAZv0yO1gyvDYgORWP")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(myUrl) { (data, response, error) -> Void in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                self.currentTempF = json["ambient_temperature_f"] as AnyObject? as? Double
            }
            catch {
                self.currentTempF = nil
            }
            
            self.lastUpdate = NSDate()
            
            dispatch_async(dispatch_get_main_queue()){
                refresh()
            }
        }
        task.resume()
        
        
        let myUrl2 = NSURL(string: "https://api.enphaseenergy.com/api/v2/systems/359168/summary?key=e5b803bbb7ec0726a4db38b811ad2c97&user_id=4d7a45304d5463790a")!
        
        let task2 = NSURLSession.sharedSession().dataTaskWithURL(myUrl2) { (data, response, error) -> Void in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                self.todaysProductionWH = json["energy_today"] as AnyObject? as? Int
            }
            catch {
                self.todaysProductionWH = nil
            }
            
            self.lastUpdate = NSDate()
            
            dispatch_async(dispatch_get_main_queue()){
                refresh()
            }
        }
        task2.resume()
    }
}