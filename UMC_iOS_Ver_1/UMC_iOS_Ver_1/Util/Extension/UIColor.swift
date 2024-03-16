//
//  UIColor.swift
//  UMC_iOS_Ver_1
//
//  Created by 신태원 on 2023/01/07.
//

import UIKit

extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
    class var mainOrange: UIColor { UIColor(hex: 0xF5663F) }
    static let mainTextColor: UIColor = UIColor(hex: 0x1E2022)
    static let subTextColor: UIColor = UIColor(hex: 0x52616A)
    static let sub2: UIColor = UIColor(hex: 0xADB5BD)
    static let sub3: UIColor = UIColor(hex: 0xC9D6DE)
    static let sub4: UIColor = UIColor(hex: 0xF0F5F9)
}
