// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum L10n {
  /// Bad Network
  public static let badNetworkMessage = L10n.tr("Localizable", "badNetworkMessage")
  /// clouds
  public static let clouds = L10n.tr("Localizable", "Clouds")
  /// It's cold!
  public static let coldWeather = L10n.tr("Localizable", "ColdWeather")
  /// Error
  public static let errorTitle = L10n.tr("Localizable", "errorTitle")
  /// Unavailable or lost Network.
  public static let errorUnavailableNetwork = L10n.tr("Localizable", "errorUnavailableNetwork")
  /// It's hot!
  public static let hotWeather = L10n.tr("Localizable", "HotWeather")
  /// humidity
  public static let humidity = L10n.tr("Localizable", "Humidity")
  /// Network available
  public static let networkAvailableMessage = L10n.tr("Localizable", "networkAvailableMessage")
  /// No
  public static let noTitle = L10n.tr("Localizable", "noTitle")
  /// OK
  public static let okTitle = L10n.tr("Localizable", "okTitle")
  /// Atmospheric pressure
  public static let pressure = L10n.tr("Localizable", "Pressure")
  /// rain
  public static let rain = L10n.tr("Localizable", "Rain")
  /// snow risk
  public static let snowRisk = L10n.tr("Localizable", "SnowRisk")
  /// Weather
  public static let weather = L10n.tr("Localizable", "Weather")
  /// Yes
  public static let yesTitle = L10n.tr("Localizable", "yesTitle")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
