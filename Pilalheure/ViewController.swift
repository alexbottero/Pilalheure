//
//  ViewController.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0).cgColor
        let color2 = UIColor(red: 0.4, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1]
        self.view.layer.insertSublayer(gradientLayer,at: 0)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

