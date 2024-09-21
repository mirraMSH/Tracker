//
//  Colors Extention.swift
//  Tracker
//
//  Created by Мария Шагина on 07.07.2024.
//

import UIKit

final class Colors {
    var viewBackgroundColor = UIColor.systemBackground
    var datePickerTintColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor.black : UIColor.black
    }
}

extension UIColor {
    static var ypBackgroundnight: UIColor { UIColor(named: "Background[night]") ?? UIColor.darkGray}
    static var backgroundColor: UIColor { UIColor(named: "bgColor") ?? UIColor.lightGray}
    static var searchColor: UIColor { UIColor(named: "SearchColor") ?? UIColor.gray }
    static var datePickerColor: UIColor { UIColor(named: "datePickerColor") ?? UIColor.gray}
    static var datePickerTintColor: UIColor { UIColor(named: "datePickerTintColor") ?? UIColor.black}
    static var ypBlack: UIColor { UIColor(named: "yBlack") ?? UIColor.black}
    static var ypBlue: UIColor { UIColor(named: "yBlue") ?? UIColor.blue}
    static var ypGray: UIColor { UIColor(named: "yGray") ?? UIColor.gray}
    static var ypLightGray: UIColor { UIColor(named: "yLightGray") ?? UIColor.lightGray}
    static var ypRed: UIColor { UIColor(named: "yRed") ?? UIColor.red}
    static var ypWhite: UIColor { UIColor(named: "yWhite") ?? UIColor.white}
    static var ypGradientColor1: UIColor { UIColor(named: "gradientColor1") ?? UIColor.red }
    static var ypGradientColor2: UIColor { UIColor(named: "gradientColor2") ?? UIColor.green }
    static var ypGradientColor3: UIColor { UIColor(named: "gradientColor3") ?? UIColor.blue }
    
    static var ypColorSelection1: UIColor? { return UIColor(named: "Color selection 1")}
    static var ypColorSelection2: UIColor? { return UIColor(named: "Color selection 2")}
    static var ypColorSelection3: UIColor? { return UIColor(named: "Color selection 3")}
    static var ypColorSelection4: UIColor? { return UIColor(named: "Color selection 4")}
    static var ypColorSelection5: UIColor? { return UIColor(named: "Color selection 5")}
    static var ypColorSelection6: UIColor? { return UIColor(named: "Color selection 6")}
    static var ypColorSelection7: UIColor? { return UIColor(named: "Color selection 7")}
    static var ypColorSelection8: UIColor? { return UIColor(named: "Color selection 8")}
    static var ypColorSelection9: UIColor? { return UIColor(named: "Color selection 9")}
    static var ypColorSelection10: UIColor? { return UIColor(named: "Color selection 10")}
    static var ypColorSelection11: UIColor? { return UIColor(named: "Color selection 11")}
    static var ypColorSelection12: UIColor? { return UIColor(named: "Color selection 12")}
    static var ypColorSelection13: UIColor? { return UIColor(named: "Color selection 13")}
    static var ypColorSelection14: UIColor? { return UIColor(named: "Color selection 14")}
    static var ypColorSelection15: UIColor? { return UIColor(named: "Color selection 15")}
    static var ypColorSelection16: UIColor? { return UIColor(named: "Color selection 16")}
    static var ypColorSelection17: UIColor? { return UIColor(named: "Color selection 17")}
    static var ypColorSelection18: UIColor? { return UIColor(named: "Color selection 18")}
    
    var hexString: String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
}

extension UIColor {
  static var ypBG: UIColor {
        if let color = UIColor(named: "YP White") {
            return color
        } else {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
                } else {
                    return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
    }
}
