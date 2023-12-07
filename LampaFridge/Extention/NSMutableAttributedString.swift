//
//  NSMutableAttributedString.swift
//  Fitness
//
//  Created by Oleksii Kalinchuk on 12.07.2023.
//  Copyright © 2023 com.ecvillib. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    public func addAttributesFor(subString: String,
                                 font: UIFont? = nil,
                                 color: UIColor? = nil,
                                 underline: Bool = false) {
        let range = mutableString.range(of: subString)
        guard range.location != NSNotFound else { return }
        if let font = font {
            addAttribute(.font, value: font, range: range)
        }
        if let color = color {
            addAttribute(.foregroundColor, value: color, range: range)
        }
        if underline {
            addAttribute(.underlineStyle, value: 1, range: range)
        }
    }
}
