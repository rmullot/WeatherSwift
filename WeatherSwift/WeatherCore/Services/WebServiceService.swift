//
//  WebServiceService.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import UIKit
import SwiftMessages

public enum Result<T> {
  case success(T)
  case error(String)
}

public protocol WebServiceServiceProtocol {
  func getForecastList(completionHandler: @escaping (Result<[ForecastStruct]>) -> Void)
  func cancelRequests()
}

public final class WebServiceService: WebServiceServiceProtocol {

  public var onlineMode: OnlineMode = .online
  public static let sharedInstance = WebServiceService()

  private let uri = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&mode=json&units=metrics&cnt=16&appid=%@"
  private let apiKey = "648a3aac37935e5b45e09727df728ac2"

  private var urlForecast = ""

  private let marginMessageBox: CGFloat = 20
  private let defaultCoordinates = CGPoint(x: 48.85341, y: 2.3488)

  public func getForecastList(completionHandler: @escaping (Result<[ForecastStruct]>) -> Void) {

    PermissionService.sharedInstance.requestLocationPermission({ (permissionStatus) in

      switch permissionStatus {
      case .granted :
        PermissionService.sharedInstance.locationUpdatedCompletionHandler = { (permissionStatus, coordinates) in
          self.urlForecast = String(format: self.uri, coordinates.x, coordinates.y, self.apiKey)
          self.launchForecastRequest(completionHandler: { (result) in
            completionHandler(result)
          })
        }
        PermissionService.sharedInstance.startLocalisation()

      default :
        self.launchForecastRequest(completionHandler: { (result) in
          completionHandler(result)
        })
      }

    })

  }

  private func launchForecastRequest(completionHandler: @escaping (Result<[ForecastStruct]>) -> Void) {
    self.getDataWith(urlString: urlForecast, completion: { (result) in
      switch result {
      case .success(let data):
        ParserService<ForecastListRoot>.parse(data, completionHandler: { result in
          switch result {
          case .success(let forecastRoot):

            guard let forecasts  = forecastRoot?.forecastList else {
              completionHandler(.error("Returned object is not an array of ForecastStruct type"))
              return
            }
            completionHandler(.success(forecasts))
          case .failure(_, let message):
            // We try at least to check if we have something in cache
            completionHandler(.error(message))
          }
        })

      case .error(let message):
        ErrorService.sharedInstance.showErrorMessage(message: message)
        completionHandler(.error(message))
      }
    })
  }

  public func cancelRequests() {
    URLSession.shared.getTasksWithCompletionHandler { (dataTask, uploadTask, downloadTask) in
      for task in dataTask {
        task.cancel()
      }
      for task in uploadTask {
        task.cancel()
      }
      for task in downloadTask {
        task.cancel()
      }
      NetworkActivityService.sharedInstance.disableActivityIndicator()
    }
  }

  private func getDataWith(urlString: String, completion: @escaping (Result<Data>) -> Void) {
    guard let url = URL(string: urlString) else {
      return completion(.error("Invalid URL, we can't update your feed")) }

    NetworkActivityService.sharedInstance.newRequestStarted()
    URLSession.shared.dataTask(with: url) { (data, _, error) in
      DispatchQueue.main.async {
        NetworkActivityService.sharedInstance.requestFinished()
        guard error == nil else {
          return completion(.error(error!.localizedDescription)) }
        guard let data = data else { return completion(.error(error?.localizedDescription ?? "There are no new Items to show")) }
        return completion(.success(data))
      }
      }.resume()
  }
  private init() {
    ReachabilityService.sharedInstance.delegates.add(self)
    urlForecast = String(format: uri, defaultCoordinates.x, defaultCoordinates.y, apiKey)
  }

  deinit {
    ReachabilityService.sharedInstance.delegates.remove(self)
  }

  private func displayNetworkStatus() {
    let view = MessageView.viewFromNib(layout: .cardView)
    switch onlineMode {
    case .offline:
      view.configureTheme(.warning)
      view.configureContent(title: L10n.errorTitle, body: L10n.errorUnavailableNetwork)
    case .onlineSlow:
      view.configureTheme(.warning)
      view.configureContent(title: L10n.errorTitle, body: L10n.badNetworkMessage)
    case .online:
      view.configureTheme(.success)
      view.configureContent(title: L10n.okTitle, body: L10n.networkAvailableMessage)
    }
    SwiftMessages.show {
      view.configureDropShadow()
      view.button?.isHidden = true
      view.layoutMarginAdditions = UIEdgeInsets(top: self.marginMessageBox, left: self.marginMessageBox, bottom: self.marginMessageBox, right: self.marginMessageBox)
      (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
      return view
    }
  }
}

// MARK: - ReachabilityManagerDelegate
extension WebServiceService: ReachabilityServiceDelegate {

  public func onlineModeChanged(_ newMode: OnlineMode) {
    if onlineMode != newMode {
      onlineMode = newMode
      displayNetworkStatus()
    }
  }
}
