//
//  UIColor+HSV.swift
//  ColorWithHSV
//
//  Created by GabrielMassana on 03/04/2016.
//  Copyright © 2016 GabrielMassana. All rights reserved.
//
//  Formula: https://en.wikipedia.org/wiki/HSL_and_HSV#From_HSL
//

import UIKit

public extension UIColor {
    
    //MARK: - Public method
    
    /**
    Creates UIColor object based on given HSV values.
    
    - parameter hue: CGFloat with the hue value. Hue value must be between 0 and 360.
    - parameter saturation: CGFloat with the saturation value. Saturation value must be between 0 and 1.
    - parameter value: CGFloat with the value value. Value value must be between 0 and 1.
    
    - returns: A UIColor from the given HSV values.
    */
    @objc(hsv_colorWithHue:saturation:value:)
    public class func colorWithHSV(hue: CGFloat, saturation: CGFloat, value: CGFloat) -> UIColor? {
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        
        guard hue <= 360.0 && hue >= 0.0 else { return nil }
        guard saturation <= 1.0 && saturation >= 0.0 else { return nil }
        guard value <= 1.0 && value >= 0.0 else { return nil }
        
        let chroma: CGFloat = value * saturation
        let h60: CGFloat = hue / 60.0
        let x: CGFloat = chroma * (1 - abs(( h60.truncatingRemainder(dividingBy: 2) ) - 1))

        if (h60 < 1) {
            
            r = chroma
            g = x
        }
        else if (h60 < 2)
        {
            r = x
            g = chroma
        }
        else if (h60 < 3)
        {
            g = chroma
            b = x
        }
        else if (h60 < 4)
        {
            g = x
            b = chroma
        }
        else if (h60 < 5)
        {
            r = x
            b = chroma
        }
        else if (h60 < 6)
        {
            r = chroma
            b = x
        }
        
        let m: CGFloat = value - chroma
        
        r = r + m
        g = g + m
        b = b + m
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
