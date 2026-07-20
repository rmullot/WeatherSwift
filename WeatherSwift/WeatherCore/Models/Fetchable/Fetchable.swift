//
//  Fetchable.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import CoreData

public protocol Fetchable {
  associatedtype FetchableType: NSManagedObject

  static var entityName: String { get }
}

extension Fetchable where FetchableType == Self {
  public static func singleObjectInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: [String: Bool]? = nil) throws -> FetchableType? {
    let managedObjects: [FetchableType] = try objectsInContext(context, predicate: predicate, sortedBy: sortedBy)
    guard managedObjects.isNotEmpty else {
      return nil }

    return managedObjects.first
  }

  public static func objectCountInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> Int {
    let request = fetchRequest(context, predicate: predicate)

    do {
      let count = try context.count(for: request)
      return count
    } catch {
      return 0
    }

  }

  public static func objectsInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: [String: Bool]? = nil) throws -> [FetchableType] {
    let request = fetchRequest(context, predicate: predicate, sortedBy: sortedBy)
    let fetchResults = try context.fetch(request)

    return fetchResults as! [FetchableType]
  }

  public static func fetchedResultsController(_ context: NSManagedObjectContext, request: NSFetchRequest<NSFetchRequestResult>, sectionName: String? = nil, cacheName: String? = nil) -> NSFetchedResultsController<NSFetchRequestResult> {
    return  NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionName, cacheName: cacheName)
  }

  public static func fetchedResultsController(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: [String: Bool]? = nil, sectionName: String? = nil, cacheName: String? = nil) -> NSFetchedResultsController<NSFetchRequestResult> {
    let request = fetchRequest(context, predicate: predicate, sortedBy: sortedBy)
    return  NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionName, cacheName: cacheName)
  }

  public static func fetchRequest(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: [String: Bool]? = nil) -> NSFetchRequest<NSFetchRequestResult> {
    let request = NSFetchRequest<NSFetchRequestResult>()
    let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
    request.entity = entity

    if predicate != nil {
      request.predicate = predicate
    }

    if sortedBy != nil {
      var sortDescriptors = [NSSortDescriptor]()
      for (key, value) in sortedBy! {
        let sort = NSSortDescriptor(key: key, ascending: value)
        sortDescriptors.append(sort)
      }

      request.sortDescriptors = sortDescriptors
    }

    return request
  }
}
