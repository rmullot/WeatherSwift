//
//  FormatterService.swift
//  WeatherCore
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation

public protocol FormatterServiceProtocol {
  func rebootCache()
  func formatterWith(format: String, timeZone: TimeZone, locale: Locale) -> DateFormatter
  func formatterWith(format: String, locale: String?) -> DateFormatter
  func formatterWith(format: String, locale: String?, timeZone: TimeZone) -> DateFormatter
  func parserDateFormatter() -> DateFormatter
  func nameForDate(_ date: Date) -> String
}

public final class FormatterService: FormatterServiceProtocol {

  public static let sharedInstance = FormatterService()

  // MARK: Properties

  private var cachedFormatters = [String: Formatter]()
  private let parserKey = "parserDateFormatter"

  // MARK: Initialization

  private init() {
    NotificationCenter.default.addObserver(self, selector: #selector(FormatterService.rebootCache), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Cache

  @objc public func rebootCache() {
    cachedFormatters = cachedFormatters.filter { key, value in
      return !(value is DateFormatter && key != parserKey)
    }
    print(cachedFormatters)
  }

  // MARK: Getting formatters

  public func formatterWith(format: String, timeZone: TimeZone = TimeZone.autoupdatingCurrent, locale: Locale = Locale(identifier: "fr_FR")) -> DateFormatter {
    let key = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"

    if let cachedDateFormatter = cachedFormatters[key] as? DateFormatter {
      return cachedDateFormatter
    } else {
      let newDateFormatter = DateFormatter()
      newDateFormatter.dateFormat = format
      newDateFormatter.timeZone = timeZone
      newDateFormatter.locale = locale
      cachedFormatters[key] = newDateFormatter
      return newDateFormatter
    }
  }

  public func formatterWith(format: String, locale: String?) -> DateFormatter {
    if let locale = locale {
      return self.formatterWith(format: format, timeZone: TimeZone.autoupdatingCurrent, locale: Locale(identifier: locale))
    } else {
      return self.formatterWith(format: format)
    }
  }

  public func formatterWith(format: String, locale: String?, timeZone: TimeZone) -> DateFormatter {
    if let locale = locale {
      return self.formatterWith(format: format, timeZone: TimeZone.autoupdatingCurrent, locale: Locale(identifier: locale))
    } else {
      return self.formatterWith(format: format, timeZone: timeZone)
    }
  }

  // Method permitting to have access directly to the formatter used for json parsing
  public func parserDateFormatter() -> DateFormatter {
    if let cachedDateFormatter = cachedFormatters[parserKey] as? DateFormatter {
      return cachedDateFormatter
    } else {
      let newDateFormatter = DateFormatter()
      newDateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
      cachedFormatters[parserKey] = newDateFormatter
      return newDateFormatter
    }
  }

  // MARK: Utilities
  public func nameForDate(_ date: Date) -> String {

    let createdToday = Calendar.current.isDateInToday(date)

    var finalStringDate = ""
    if createdToday {
      finalStringDate = "Aujourd'hui"
      let formatter = self.formatterWith(format: "HH':'mm")
      let stringDate = formatter.string(from: date)
      finalStringDate.append(" à \(stringDate)")
    } else {
      let formatter = self.formatterWith(format: "EEEE' 'dd' 'MMMM' 'yyyy' à 'HH':'mm")
      let stringDate = formatter.string(from: date)
      finalStringDate = stringDate
    }

    return finalStringDate
  }

  static func convertFahrenheitInCelsius(_ fahrenheit: Double) -> Double {
    return  (fahrenheit - 32) / 1.8000
  }

  static func convertKelvinInCelsius(_ kelvin: Double) -> Double {
    return  kelvin - 273.15
  }
}
