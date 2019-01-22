//
//  Weather+Fetchable.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation
import CoreData

extension Forecast: Fetchable {

    public typealias FetchableType = Forecast

    static public var entityName: String {
        return "Forecast"
    }

}
