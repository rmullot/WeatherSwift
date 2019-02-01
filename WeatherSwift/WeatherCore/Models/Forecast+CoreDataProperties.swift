//
//  Forecast+CoreDataProperties.swift
//  
//
//  Created by Romain Mullot on 22/01/2019.
//
//

import Foundation
import CoreData

extension Forecast {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
    return NSFetchRequest<Forecast>(entityName: "Forecast")
  }

  @NSManaged public var temperature: Float
  @NSManaged public var pressure: Int32
  @NSManaged public var rain: Float
  @NSManaged public var snowRisk: String?
  @NSManaged public var date: NSDate?

}
