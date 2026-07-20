//
//  Forecast+Parsing.swift
//  WeatherCore
//
//  Created by Romain Mullot on 03/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

struct WeatherStruct: Decodable {
  public let idWeather: Int
  public let main: String
  public let description: String
  public let icon: String

  enum CodingKeys: String, CodingKey {
    case idWeather = "id"
    case main = "main"
    case description = "description"
    case icon = "icon"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    idWeather = try values.decode(Int.self, forKey: .idWeather)
    main = try values.decode(String.self, forKey: .main)
    description = try values.decode(String.self, forKey: .description)
    icon = try values.decode(String.self, forKey: .icon)
  }
}

public struct TemperatureStruct: Decodable {
  public let min: Float
  public let max: Float
  public let day: Float
  public let night: Float
  public let evening: Float
  public let morning: Float

  enum CodingKeys: String, CodingKey {
    case min = "min"
    case max = "max"
    case day = "day"
    case night = "night"
    case evening = "eve"
    case morning = "morn"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    min = try values.decode(Float.self, forKey: .min)
    max = try values.decode(Float.self, forKey: .max)
    day = try values.decode(Float.self, forKey: .day)
    night = try values.decode(Float.self, forKey: .night)
    evening = try values.decode(Float.self, forKey: .evening)
    morning = try values.decode(Float.self, forKey: .morning)
  }
}

struct ErrorAPIStruct: Decodable {
  public let code: Int
  public let message: String

  enum CodingKeys: String, CodingKey {
    case code = "cod"
    case message = "message"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    code = try values.decode(Int.self, forKey: .code)
    message = try values.decode(String.self, forKey: .message)
  }
}

struct ForecastListRoot: Decodable {
  public let code: String
  public let message: Float
  public var forecastList: [ForecastStruct]

  enum CodingKeys: String, CodingKey {
    case code = "cod"
    case message = "message"
    case forecastList = "list"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    code = try values.decode(String.self, forKey: .code)
    message = try values.decode(Float.self, forKey: .message)
    self.forecastList = [ForecastStruct]()
    let results = try values.decode([ForecastStruct].self, forKey: .forecastList)
    self.forecastList.insert(contentsOf: results, at: 0)
  }
}

public struct ForecastStruct: Decodable {
  public var date: Double = 0
  public var pressure: Float = 0
  public let humidity: Int?
  public let speed: Float?
  public var temperature: TemperatureStruct?
  public var deg: Float?
  public var winds: Float?
  public var clouds: Float?
  public var rain: Float?
  public var snow: Float?
  public var informations: String = ""
  public var idImage: String = ""

  enum CodingKeys: String, CodingKey {
    case weather = "weather"
    case date = "dt"
    case pressure = "pressure"
    case humidity = "humidity"
    case speed = "speed"
    case deg = "deg"
    case clouds = "clouds"
    case rain = "rain"
    case snow = "snow"
    case winds = "winds"
    case temperature = "temp"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    date = try values.decode(Double.self, forKey: .date)
    pressure = try values.decode(Float.self, forKey: .pressure)
    speed = try values.decodeIfPresent(Float.self, forKey: .speed)
    humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
    rain = try values.decodeIfPresent(Float.self, forKey: .rain)
    snow = try values.decodeIfPresent(Float.self, forKey: .snow)
    winds = try values.decodeIfPresent(Float.self, forKey: .winds)
    clouds = try values.decodeIfPresent(Float.self, forKey: .clouds)

    let weathers = try values.decode([WeatherStruct].self, forKey: .weather)
    if weathers.isNotEmpty {
      informations =  weathers[0].description
      idImage = "http://openweathermap.org/img/w/\(weathers[0].icon).png"
    }

    deg = try values.decodeIfPresent(Float.self, forKey: .deg)
    temperature = try values.decodeIfPresent(TemperatureStruct.self, forKey: .temperature)
  }
}
