// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#002f35"></span>
  /// Alpha: 25% <br/> (0x002f3542)
  internal static let abyss = ColorName(rgbaValue: 0x002f3542)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00d6c2"></span>
  /// Alpha: 47% <br/> (0x00d6c27a)
  internal static let abyssAlphaFade = ColorName(rgbaValue: 0x00d6c27a)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00262a"></span>
  /// Alpha: 20% <br/> (0x00262a35)
  internal static let abyssDark = ColorName(rgbaValue: 0x00262a35)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#002125"></span>
  /// Alpha: 18% <br/> (0x0021252e)
  internal static let abyssDarker = ColorName(rgbaValue: 0x0021252e)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00d5d7"></span>
  /// Alpha: 85% <br/> (0x00d5d7d9)
  internal static let abyssFade = ColorName(rgbaValue: 0x00d5d7d9)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00ec00"></span>
  /// Alpha: 25% <br/> (0x00ec0041)
  internal static let dahlia = ColorName(rgbaValue: 0x00ec0041)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00a6a6"></span>
  /// Alpha: 65% <br/> (0x00a6a6a6)
  internal static let dahliaAlphaFade = ColorName(rgbaValue: 0x00a6a6a6)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00bd00"></span>
  /// Alpha: 20% <br/> (0x00bd0034)
  internal static let dahliaDark = ColorName(rgbaValue: 0x00bd0034)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00a500"></span>
  /// Alpha: 18% <br/> (0x00a5002e)
  internal static let dahliaDarker = ColorName(rgbaValue: 0x00a5002e)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00fbcc"></span>
  /// Alpha: 85% <br/> (0x00fbccd9)
  internal static let dahliaFade = ColorName(rgbaValue: 0x00fbccd9)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00d8dd"></span>
  /// Alpha: 90% <br/> (0x00d8dde6)
  internal static let fog = ColorName(rgbaValue: 0x00d8dde6)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#002e38"></span>
  /// Alpha: 28% <br/> (0x002e3848)
  internal static let fogAlphaFade = ColorName(rgbaValue: 0x002e3848)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00a0ac"></span>
  /// Alpha: 76% <br/> (0x00a0acc2)
  internal static let fogDark = ColorName(rgbaValue: 0x00a0acc2)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#008797"></span>
  /// Alpha: 69% <br/> (0x008797b2)
  internal static let fogDarker = ColorName(rgbaValue: 0x008797b2)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00f3f5"></span>
  /// Alpha: 97% <br/> (0x00f3f5f8)
  internal static let fogFade = ColorName(rgbaValue: 0x00f3f5f8)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#004754"></span>
  /// Alpha: 43% <br/> (0x00475470)
  internal static let midnight = ColorName(rgbaValue: 0x00475470)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#002b34"></span>
  /// Alpha: 1% <br/> (0x002b3404)
  internal static let midnightAlphaFade = ColorName(rgbaValue: 0x002b3404)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#003943"></span>
  /// Alpha: 35% <br/> (0x0039435a)
  internal static let midnightDark = ColorName(rgbaValue: 0x0039435a)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00323b"></span>
  /// Alpha: 30% <br/> (0x00323b4e)
  internal static let midnightDarker = ColorName(rgbaValue: 0x00323b4e)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#00dadd"></span>
  /// Alpha: 88% <br/> (0x00dadde2)
  internal static let midnightFade = ColorName(rgbaValue: 0x00dadde2)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
