//
//  WebServiceService.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import UIKit
import SwiftMessages

public enum Result<T> {
  case success(T)
  case error(String)
}

public final class WebServiceService {

  public var onlineMode: OnlineMode = .online
  public static let sharedInstance = WebServiceService()

  private let uri = "http://www.infoclimat.fr/public-api/gfs/json?"
  private let auth = "&_auth=ARsDFAR6ACJXelNkAXdSewRsADULfVVyAX0KaVw5UC0HbARlUTFcOgBuUi8GKQs9Ay5UNwkyAzMAa1IqD30AYQFrA28EbwBnVzhTNgEuUnkEKgBhCytVcgFlCmVcL1AyB20EYlEsXDwAb1IuBjQLPgMyVCsJKQM6AGZSMQ9qAGIBZwNvBGYAa1c8Uy4BLlJjBGQAZAszVW0BZgo7XDNQZQdnBGdRZFw%2FAG5SLgYyCzsDMlQ0CTEDOABjUjQPfQB8ARsDFAR6ACJXelNkAXdSewRiAD4LYA%3D%3D&_c=f6c617cc089e19e12abda28b724dca82"

  private var urlForecast = ""

  private let marginMessageBox: CGFloat = 20

  public func getForecastList(completionHandler: @escaping (Result<[ForecastStruct]>) -> Void) {

    PermissionService.sharedInstance.requestLocationPermission({ (permissionStatus) in

      switch permissionStatus {
      case .granted :
        PermissionService.sharedInstance.locationUpdatedCompletionHandler = { (permissionStatus, coordinates) in
          self.urlForecast = "\(self.uri)_ll=\(coordinates.x),\(coordinates.y)\(self.auth)"
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
        ParserService.parseForecastsFromJSON(data, completionHandler: { result in
          switch result {
          case .success(let forecasts):
            guard let forecasts  = forecasts as? [ForecastStruct] else {
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
    urlForecast = "\(uri)_ll=48.85341,2.3488\(auth)"
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
