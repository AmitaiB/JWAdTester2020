// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// licenseKey
  internal static let licenseKey = L10n.tr("localizable", "licenseKey")
  /// MementoKey
  internal static let mementoKey = L10n.tr("localizable", "MementoKey")
  /// SelectedThemeKey
  internal static let selectedThemeKey = L10n.tr("localizable", "SelectedThemeKey")
  /// com.jwplayer.JWAdTester2020
  internal static let comJwplayerJWAdTester2020 = L10n.tr("localizable", "com.jwplayer.JWAdTester2020")
  /// group.com.jwplayer.JWAdTester2020
  internal static let groupComJwplayerJWAdTester2020 = L10n.tr("localizable", "group.com.jwplayer.JWAdTester2020")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
