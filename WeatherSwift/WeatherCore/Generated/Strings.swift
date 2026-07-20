// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Localizable.strings
  ///   
  /// 
  ///   Created by Romain Mullot on 15/01/2019.
  public static let badNetworkMessage = L10n.tr("Localizable", "badNetworkMessage", fallback: "Bad Network")
  /// clouds
  public static let clouds = L10n.tr("Localizable", "Clouds", fallback: "clouds")
  /// It's cold!
  public static let coldWeather = L10n.tr("Localizable", "ColdWeather", fallback: "It's cold!")
  /// Error
  public static let errorTitle = L10n.tr("Localizable", "errorTitle", fallback: "Error")
  /// Unavailable or lost Network.
  public static let errorUnavailableNetwork = L10n.tr("Localizable", "errorUnavailableNetwork", fallback: "Unavailable or lost Network.")
  /// It's hot!
  public static let hotWeather = L10n.tr("Localizable", "HotWeather", fallback: "It's hot!")
  /// humidity
  public static let humidity = L10n.tr("Localizable", "Humidity", fallback: "humidity")
  /// Network available
  public static let networkAvailableMessage = L10n.tr("Localizable", "networkAvailableMessage", fallback: "Network available")
  /// No
  public static let noTitle = L10n.tr("Localizable", "noTitle", fallback: "No")
  /// OK
  public static let okTitle = L10n.tr("Localizable", "okTitle", fallback: "OK")
  /// Atmospheric pressure
  public static let pressure = L10n.tr("Localizable", "Pressure", fallback: "Atmospheric pressure")
  /// rain
  public static let rain = L10n.tr("Localizable", "Rain", fallback: "rain")
  /// snow risk
  public static let snowRisk = L10n.tr("Localizable", "SnowRisk", fallback: "snow risk")
  /// Weather
  public static let weather = L10n.tr("Localizable", "Weather", fallback: "Weather")
  /// Yes
  public static let yesTitle = L10n.tr("Localizable", "yesTitle", fallback: "Yes")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
