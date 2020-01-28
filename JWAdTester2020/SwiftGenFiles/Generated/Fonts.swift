// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
  internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  internal typealias Font = UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum Inconsolata {
    internal static let bold = FontConvertible(name: "Inconsolata-Bold", family: "Inconsolata", path: "inconsolata-bold.ttf")
    internal static let regular = FontConvertible(name: "Inconsolata-Regular", family: "Inconsolata", path: "inconsolata-regular.ttf")
    internal static let all: [FontConvertible] = [bold, regular]
  }
  internal enum Lato {
    internal static let black = FontConvertible(name: "Lato-Black", family: "Lato", path: "lato-black.ttf")
    internal static let bold = FontConvertible(name: "Lato-Bold", family: "Lato", path: "lato-bold.ttf")
    internal static let light = FontConvertible(name: "Lato-Light", family: "Lato", path: "lato-light.ttf")
    internal static let regular = FontConvertible(name: "Lato-Regular", family: "Lato", path: "lato-regular.ttf")
    internal static let all: [FontConvertible] = [black, bold, light, regular]
  }
  internal enum OpenSans {
    internal static let bold = FontConvertible(name: "OpenSans-Bold", family: "Open Sans", path: "opensans-bold.ttf")
    internal static let extraBold = FontConvertible(name: "OpenSans-ExtraBold", family: "Open Sans", path: "opensans-extrabold.ttf")
    internal static let italic = FontConvertible(name: "OpenSans-Italic", family: "Open Sans", path: "opensans-italic.ttf")
    internal static let light = FontConvertible(name: "OpenSans-Light", family: "Open Sans", path: "opensans-light.ttf")
    internal static let regular = FontConvertible(name: "OpenSans-Regular", family: "Open Sans", path: "opensans-regular.ttf")
    internal static let semiBold = FontConvertible(name: "OpenSans-SemiBold", family: "Open Sans", path: "opensans-semibold.ttf")
    internal static let all: [FontConvertible] = [bold, extraBold, italic, light, regular, semiBold]
  }
  internal enum Overpass {
    internal static let regular = FontConvertible(name: "Overpass-Regular", family: "Overpass", path: "overpass-regular.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum OverpassExtraBold {
    internal static let regular = FontConvertible(name: "Overpass-ExtraBold", family: "Overpass ExtraBold", path: "overpass-extrabold.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum OverpassLight {
    internal static let regular = FontConvertible(name: "Overpass-Light", family: "Overpass Light", path: "overpass-light.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal static let allCustomFonts: [FontConvertible] = [Inconsolata.all, Lato.all, OpenSans.all, Overpass.all, OverpassExtraBold.all, OverpassLight.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  internal func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    let bundle = Bundle(for: BundleToken.self)
    return bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension Font {
  convenience init!(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

private final class BundleToken {}
