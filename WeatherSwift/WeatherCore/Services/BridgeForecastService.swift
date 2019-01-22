//
//  BridgeForecastService.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import CoreData

protocol BridgeForecastServiceProtocol {
  static func getForecasts(completionHandler: @escaping ([Forecast]?) -> Void)
}

public final class BridgeForecastService: BridgeForecastServiceProtocol {

    private init() {}

    public static func getForecasts(completionHandler: @escaping ([Forecast]?) -> Void) {
        var forecasts: [Forecast]?
        do {
            try forecasts = Forecast.objectsInContext(CoreDataService.sharedInstance.persistentContainer.viewContext, predicate: nil, sortedBy: ["date": true])

            if WebServiceService.sharedInstance.onlineMode != .offline {
                BridgeForecastService.callWebservice(completionHandler: { () -> Void in
                    do {
                        try forecasts = Forecast.objectsInContext(CoreDataService.sharedInstance.persistentContainer.viewContext, predicate: nil, sortedBy: ["date": true])
                        completionHandler(forecasts)
                    } catch let error {
                        print("ERROR: no forecast in cache  \(error)")
                    }
                })
            } else {
                completionHandler(forecasts)
            }
        } catch let error {
            print("ERROR: no forecast in cache  \(error)")
        }

    }

    static private func callWebservice(completionHandler: @escaping () -> Void) {
      WebServiceService.sharedInstance.getForecastList { (result) in
        switch result {
        case .success(let forecasts):
          CoreDataService.sharedInstance.clearData()
          CoreDataService.sharedInstance.saveForecastsData(forecasts)
          completionHandler()
        case .error(let message):
          print(message)
          completionHandler()
        }
      }
    }

}
