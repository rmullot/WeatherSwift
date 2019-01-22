// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Bad Network
  internal static let badNetworkMessage = L10n.tr("Localizable", "badNetworkMessage")
  /// Error
  internal static let errorTitle = L10n.tr("Localizable", "errorTitle")
  /// Unavailable or lost Network.
  internal static let errorUnavailableNetwork = L10n.tr("Localizable", "errorUnavailableNetwork")
  /// Network available
  internal static let networkAvailableMessage = L10n.tr("Localizable", "networkAvailableMessage")
  /// No
  internal static let noTitle = L10n.tr("Localizable", "noTitle")
  /// OK
  internal static let okTitle = L10n.tr("Localizable", "okTitle")
  /// Atmospheric pressure
  internal static let pressure = L10n.tr("Localizable", "Pressure")
  /// rain
  internal static let rain = L10n.tr("Localizable", "Rain")
  /// snow risk
  internal static let snowRisk = L10n.tr("Localizable", "SnowRisk")
  /// Yes
  internal static let yesTitle = L10n.tr("Localizable", "yesTitle")
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
