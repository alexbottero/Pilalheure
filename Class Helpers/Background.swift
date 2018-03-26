//
//  Background.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 26/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit

class Background{
    
    class func color(controleur:UIViewController){
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = controleur.view.bounds
            let color1 = UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0).cgColor
            let color2 = UIColor(red: 0.4, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
            gradientLayer.colors = [color1, color2]
            gradientLayer.locations = [0.0, 1]
            controleur.view.layer.insertSublayer(gradientLayer,at: 0)
        }
}
