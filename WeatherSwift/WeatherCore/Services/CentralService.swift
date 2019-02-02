//
//  CentralService.swift
//  WeatherCore
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

public protocol CentralServiceProtocol {
  func register<T>(_ factory: T)
  func resolve<T>() -> T
  func reboot()
}

/// Design Pattern InversionOfControl
public final class CentralService: CentralServiceProtocol {

  public static let sharedInstance = CentralService()

  private var registrations = [String: Any]()

  public func register<T>( _ factory: T) {
    let key = String(describing: T.self)
    print(key)
    registrations[key] = Registration<T>(factory: factory)
  }

  public func resolve<T>() -> T {
    return resolve { (builder: () -> T) in
      builder()
    }
  }
  private func resolve<T, F>(_ builder: (F) -> T) -> T {
    let key = String(describing: F.self)
    if let registration = registrations[key] as? Registration<F> {
      guard registration.instance != nil else {
        let instance = builder(registration.factory)
        registration.instance = instance
        return instance
      }
      return registration.instance as! T

    } else {
      fatalError("\(F.self) is not registered in the IoC container")
    }
  }

  public func reboot() {
    registrations.removeAll()
  }

  private init() { }
}

private class Registration<F> {

  var instance: Any?
  let factory: F

  init(factory: F, instance: Any? = nil) {
    self.factory = factory
    self.instance = instance
  }
}
