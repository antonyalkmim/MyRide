// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Alert {
    internal enum Error {
      /// Sorry!
      internal static let title = L10n.tr("Localizable", "alert.error.title")
    }
    internal enum Success {
      /// Success!
      internal static let title = L10n.tr("Localizable", "alert.success.title")
    }
  }

  internal enum DriversList {
    /// Drivers
    internal static let title = L10n.tr("Localizable", "drivers_list.title")
  }

  internal enum DriversMap {
    /// Find my Taxi
    internal static let title = L10n.tr("Localizable", "drivers_map.title")
    internal enum RequestDriver {
      /// Sorry, we could not request your ride.
      internal static let error = L10n.tr("Localizable", "drivers_map.request_driver.error")
    }
  }

  internal enum HttpError {
    /// Connection error. Please, try again later!
    internal static let connectionError = L10n.tr("Localizable", "http_error.connectionError")
    /// Connection error. Please, try again later!
    internal static let jsonMapping = L10n.tr("Localizable", "http_error.jsonMapping")
    /// There's no internet conection. Please, check your connection!
    internal static let noInternetConnection = L10n.tr("Localizable", "http_error.noInternetConnection")
    /// Unauthorized.
    internal static let unauthorized = L10n.tr("Localizable", "http_error.unauthorized")
    /// Unknow error.
    internal static let unknow = L10n.tr("Localizable", "http_error.unknow")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
