//
//  AppModel.swift
//  BatteryApp
//
//  Created by Maks on 10.05.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

class Application {
    var name: String
    var picture: String
    var batteryUsage: Int
    
    init(name: String, picture: String, batteryUsage: Int) {
        self.name = name
        self.picture = picture
        self.batteryUsage = batteryUsage
    }
    
    
}
