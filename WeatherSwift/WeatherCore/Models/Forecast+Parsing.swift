//
//  Forecast+Parsing.swift
//  WeatherSwift
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

struct ForecastListRoot: Decodable {
  public let requestState: Int
  public let message: String
  public var forecastList: [String: ForecastStruct]

  private struct CodingKeys: CodingKey {
    var intValue: Int?
    var stringValue: String

    init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
    init?(stringValue: String) { self.stringValue = stringValue }

    static let requestState = CodingKeys.make(key: "request_state")
    static let message = CodingKeys.make(key: "message")
    static func make(key: String) -> CodingKeys {
      return CodingKeys(stringValue: key)!
    }
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    requestState = try values.decode(Int.self, forKey: .requestState)
    message = try values.decode(String.self, forKey: .message)
    self.forecastList = [String: ForecastStruct]()
    let avoidedKeys = [CodingKeys.requestState.stringValue, CodingKeys.message.stringValue, "model_run", "request_key", "source"]
    for key in values.allKeys {
      guard !avoidedKeys.contains(key.stringValue) else { continue }
      var value = try values.decode(ForecastStruct.self, forKey: key)
      value.date = key.stringValue
      self.forecastList[key.stringValue] = value
    }
  }
}

public struct ForecastStruct: Codable {
  public var temperature: Float = 0
  public var pression: Int32 = 0
  public let rain: Float
  public let snowRisk: String
  public var date: String

  enum CodingKeys: String, CodingKey {
    case temperature = "temperature"
    case pression = "pression"
    case rain = "pluie"
    case snowRisk = "risque_neige"
    case date = "date"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let temperatures = try values.decode([String: Float].self, forKey: .temperature)
    if let result = temperatures["2m"] {
      temperature = result
    }
    let pressions = try values.decode([String: Int32].self, forKey: .pression)
    if let result = pressions["niveau_de_la_mer"] {
      pression = result
    }

    rain = try values.decode(Float.self, forKey: .rain)
    snowRisk = try values.decode(String.self, forKey: .snowRisk)
    date = ""
  }
}
