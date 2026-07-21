//
//  PermissionService.swift
//  WeatherCore
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation
import CoreLocation

public typealias PermissionCompletionHandler = (_ status: LocationStatus) -> Void
public typealias LocationUpdatedCompletionHandler = (_ status: LocationStatus, _ coordinates: CGPoint) -> Void

public protocol PermissionServiceProtocol {
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

  public func requestLocationPermission(_ completionHandler: PermissionCompletionHandler? = nil) {
    getPermissionStatus { status in
        guard status == .unknown else {
          completionHandler?(status)
          return
        }
        self.permissionCompletionHandler = completionHandler
        self.locationManager.requestWhenInUseAuthorization()
      }
  }

  public func startLocalisation() {
    locationManager.startUpdatingLocation()
  }

    private func getPermissionStatus(_ completionHandler: PermissionCompletionHandler? = nil) {
      let permissionQueue = DispatchQueue(label: "permissionStatusQueue")
      permissionQueue.async {
        let status: LocationStatus
        if CLLocationManager.locationServicesEnabled() {
            let manager = CLLocationManager()
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                status = .granted
            case .denied:
                status = .denied
            case .restricted:
                status = .restricted
            default:
                status = .unknown
            }
        } else {
            status = .disabled
        }

        // CLLocationManager calls (requestWhenInUseAuthorization, startUpdatingLocation) must
        // happen on a thread with an active run loop, so hand the result back to the main thread.
        DispatchQueue.main.async {
          completionHandler?(status)
        }
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
      getPermissionStatus { status in
          self.permissionCompletionHandler?(status)
          self.permissionCompletionHandler = nil
      }
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
