//
//  CoreDataService.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import CoreData

public enum CoreDataResult {
  case success(Any?)
  case failure(Swift.Error, String)
}

public enum CoreDataError: Error {
  case forecastMultiplePresent
}

public typealias CoreDataCallback = (CoreDataResult) -> Void

public protocol CoreDataServiceProtocol {
  func saveContext()
  func saveForecastsData(_ forecastStructs: [ForecastStruct])
  func clearData()
}

public final class CoreDataService: Any {

  public static let sharedInstance = CoreDataService()

  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "WeatherSwift")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  // MARK: - Core Data Saving support

  public func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        ErrorService.sharedInstance.showErrorMessage(message: "Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

  public func saveForecastsData(_ forecastStructs: [ForecastStruct]) {
    var errorMessage = ""
    forecastStructs.forEach {
      convertForecast($0, completionHandler: { result in
        switch result {
        case .failure(_, let message):
          errorMessage = message
        default:
          break
        }
      })
    }

    if errorMessage.isEmpty {
      self.saveContext()
    } else {
      ErrorService.sharedInstance.showErrorMessage(message: errorMessage)
    }
  }

  private func convertForecast(_ forecast: ForecastStruct, completionHandler: CoreDataCallback? = nil) {
    var resultObject: Forecast?

    //check if object exists already or create new one

    let predicate = NSPredicate(format: "date == %@", forecast.date.toParsedDate())
    var objects: [Forecast] = [Forecast]()

    do {
      objects = try Forecast.objectsInContext(persistentContainer.viewContext, predicate: predicate, sortedBy: nil)
    } catch let error {
      completionHandler?(CoreDataResult.failure(error, "Error fetch object : \(error)"))
      return
    }
    // more than 1 object with same id problem ?
    guard objects.count <= 1 else {
      completionHandler?(CoreDataResult.failure(CoreDataError.forecastMultiplePresent, "already in the coredata cache"))
      return
    }

    // check object already in cache
    resultObject = objects.count == 1 ? objects[0] : NSEntityDescription.insertNewObject(forEntityName: Forecast.entityName, into: persistentContainer.viewContext) as! Forecast

    resultObject?.date = forecast.date.toParsedDate()
    resultObject?.temperature = forecast.temperature
    resultObject?.pressure = forecast.pressure
    resultObject?.snowRisk = forecast.snowRisk
    resultObject?.temperature = forecast.temperature
    resultObject?.rain = forecast.rain
    completionHandler?(CoreDataResult.success(resultObject))
  }

  public func clearData() {
    do {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Forecast.entityName)
      do {
        let objects  = try self.persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject]
        objects?.forEach { self.persistentContainer.viewContext.delete($0) }
        self.saveContext()
      } catch let error {
        print("ERROR DELETING : \(error)")
      }
    }
  }

  private init() {}

}
