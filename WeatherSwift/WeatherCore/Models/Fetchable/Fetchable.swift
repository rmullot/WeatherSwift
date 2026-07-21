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
    let request = fetchRequest(predicate: predicate)

    do {
      let count = try context.count(for: request)
      return count
    } catch {
      return 0
    }

  }

  public static func objectsInContext(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: [String: Bool]? = nil) throws -> [FetchableType] {
    let request = fetchRequest(predicate: predicate, sortedBy: sortedBy)
    return try context.fetch(request)
  }

  public static func fetchedResultsController(_ context: NSManagedObjectContext, request: NSFetchRequest<FetchableType>, sectionName: String? = nil, cacheName: String? = nil) -> NSFetchedResultsController<FetchableType> {
    return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionName, cacheName: cacheName)
  }

  public static func fetchedResultsController(_ context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: [String: Bool]? = nil, sectionName: String? = nil, cacheName: String? = nil) -> NSFetchedResultsController<FetchableType> {
    let request = fetchRequest(predicate: predicate, sortedBy: sortedBy)
    return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionName, cacheName: cacheName)
  }

  public static func fetchRequest(predicate: NSPredicate? = nil, sortedBy: [String: Bool]? = nil) -> NSFetchRequest<FetchableType> {
    let request = NSFetchRequest<FetchableType>(entityName: entityName)
    request.predicate = predicate

    if let sortedBy {
      request.sortDescriptors = sortedBy.map { NSSortDescriptor(key: $0.key, ascending: $0.value) }
    }

    return request
  }
}
