//
//  PermissionService.swift
//  WeatherCore
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation
import CoreLocation

public typealias PermissionCompletionHandler = (_ status: LocationStatus) -> Void
public typealias LocationUpdatedCompletionHandler = (_ status: LocationStatus, _ coordinates: CGPoint) -> Void

public protocol PermissionServiceProtocol {

  var permissionStatus: LocationStatus { get }

  func requestLocationPermission(_ completionHandler: ((_ status: LocationStatus) -> Void)?)
  func startLocalisation()

}

public class PermissionService: NSObject, PermissionServiceProtocol {

  public static let sharedInstance = PermissionService()

  private var coordinates: CGPoint = .zero

  private var locationManager: CLLocationManager = CLLocationManager()
  private var permissionCompletionHandler: PermissionCompletionHandler?
  public var locationUpdatedCompletionHandler: LocationUpdatedCompletionHandler?

  // MARK: - Location

  public var permissionStatus: LocationStatus {
    return getPermisionStatus()
  }

  public func requestLocationPermission(_ completionHandler: PermissionCompletionHandler? = nil) {
    let status = getPermisionStatus()
    guard status == .unknown else {
      completionHandler?(status)
      return
    }
    permissionCompletionHandler = completionHandler
    self.locationManager.requestWhenInUseAuthorization()
  }

  public func startLocalisation() {
    locationManager.startUpdatingLocation()
  }

  private func getPermisionStatus() -> LocationStatus {
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

  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      coordinates.x = CGFloat(location.coordinate.latitude)
      coordinates.y = CGFloat(location.coordinate.longitude)
      locationManager.stopUpdatingLocation()
      locationUpdatedCompletionHandler?(.granted, coordinates)
      locationUpdatedCompletionHandler = nil
    }
  }

}

public enum LocationStatus {
  case denied
  case disabled
  case granted
  case restricted
  case unknown
}
