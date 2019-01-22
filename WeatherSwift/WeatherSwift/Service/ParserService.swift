//
//  ParserService.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

enum ParserResult {
    case success(Any?)
    case failure(Swift.Error, String)
}

enum ParserError: Error {
    case decodeObject
    case unknownObject
}

typealias ParserCallback = (ParserResult) -> Void

final class ParserService {

    private init() { }

    // MARK: - Food
    static func parseForecastsFromJSON(_ json: Data, completionHandler: ParserCallback? = nil) {
        do {
            let root: ForecastListRoot = try JSONDecoder().decode(ForecastListRoot.self, from: json)
            let forecasts = root.forecastList.values.compactMap { return $0 }
            completionHandler?(ParserResult.success(forecasts))
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
            completionHandler?(ParserResult.failure(ParserError.decodeObject, context.debugDescription))
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completionHandler?(ParserResult.failure(ParserError.decodeObject, context.debugDescription))
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completionHandler?(ParserResult.failure(ParserError.decodeObject, context.debugDescription))
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completionHandler?(ParserResult.failure(ParserError.decodeObject, context.debugDescription))
        } catch {
            print("error: ", error)
            completionHandler?(ParserResult.failure(ParserError.unknownObject, error.localizedDescription))
        }
    }

}
