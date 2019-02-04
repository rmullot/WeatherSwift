//
//  Forecast+CoreDataProperties.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 18/11/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import CoreData

extension Forecast {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
    return NSFetchRequest<Forecast>(entityName: "Forecast")
  }

  @NSManaged public var clouds: Float
  @NSManaged public var date: Double
  @NSManaged public var humidity: Int16
  @NSManaged public var idImage: String?
  @NSManaged public var informations: String?
  @NSManaged public var pressure: Float
  @NSManaged public var rain: Float
  @NSManaged public var snow: Float
  @NSManaged public var speed: Float
  @NSManaged public var temperature: Double
  @NSManaged public var winds: Float

}
