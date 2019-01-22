//
//  PermissionService.swift
//  WeatherCore
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation
import CoreLocation

public typealias PermissionCompletionHandler = (_ status: PermissionStatus) -> Void

public protocol PermissionServiceProtocol {

  var permissionStatus: PermissionStatus { get }

  func requestLocationPermission(_ completionHandler: ((_ status: PermissionStatus) -> Void)?)

}

public class PermissionService: NSObject, PermissionServiceProtocol {

  public static let sharedInstance = PermissionService()

  private var locationManager: CLLocationManager = CLLocationManager()
  private var permissionCompletionHandler: PermissionCompletionHandler?

  // MARK: - Location

  public var permissionStatus: PermissionStatus {
    return getPermisionStatus()
  }

  public func requestLocationPermission(_ completionHandler: ((_ status: PermissionStatus) -> Void)? = nil) {
    let status = getPermisionStatus()
    guard status == .unknown else {
      completionHandler?(status)
      return
    }
    permissionCompletionHandler = completionHandler
    self.locationManager.requestWhenInUseAuthorization()
  }

  private func getPermisionStatus() -> PermissionStatus {
    guard CLLocationManager.locationServicesEnabled() else { return .disabled }

    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      return .granted
    case .denied:
      return .denied
    case .restricted:
      return .restricted
    default:
      return .unknown
    }
  }

  private override init() {
     super.init()
     locationManager.delegate = self
  }

}

extension PermissionService: CLLocationManagerDelegate {

  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status != .notDetermined else { return }

    permissionCompletionHandler?(getPermisionStatus())
    permissionCompletionHandler = nil
  }

}

public enum PermissionStatus {
  case denied
  case disabled
  case granted
  case restricted
  case unknown
}
