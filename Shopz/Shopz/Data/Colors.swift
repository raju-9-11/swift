//
//  Colors.swift
//  Shopz
//
//  Created by Rajkumar S on 21/02/22.
//
import UIKit


extension UIColor {
    
    static var shopzBackGroundColor: UIColor = UIColor {
        traits in
        switch traits.userInterfaceStyle {
        case .dark:
            return .black
        case .light:
            return .white
        default:
            return .black
        }
    }
    
    static var appTextColor: UIColor = UIColor {
        traits in
        switch traits.userInterfaceStyle {
        case .dark:
            return .white
        case .light:
            return .black
        default:
            return .white
        }
    }
    
    static var thumbNailColor: UIColor = UIColor {
        traits in
        switch traits.userInterfaceStyle {
        case .dark:
            return .systemGray6
        case .light:
            return .white
        default:
            return .systemGray6
        }
    }
    
    static var thumbNailTextColor: UIColor = UIColor {
        traits in
        switch traits.userInterfaceStyle {
        case .dark:
            return .white
        case .light:
            return .darkGray
        default:
            return .white
        }
    }
    
    static var tabbarColor: UIColor = UIColor {
        traits in
        switch traits.userInterfaceStyle {
        case .dark:
            return .systemGray6
        case .light:
            return .white
        default:
            return .systemGray6
        }
    }
    
    static var tabbarUnselectedColor: UIColor = UIColor {
        traits in
        switch traits.userInterfaceStyle {
        case .dark:
            return .darkGray
        case .light:
            return .systemGray2
        default:
            return .darkGray
        }
    }
    
    static var subtitleTextColor: UIColor = UIColor {
        traits in
        switch traits.userInterfaceStyle {
        case .dark:
            return .systemGray2
        case .light:
            return .darkGray
        default:
            return .systemGray2
        }
    }
    
    static var profileBackGroundColor: UIColor = UIColor {
        traits in
        switch traits.userInterfaceStyle {
        case .dark:
            return .black
        case .light:
            return .systemGray3
        default:
            return .black
        }
    }
    
    
}
