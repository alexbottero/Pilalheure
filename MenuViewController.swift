//
//  LaunchViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0).cgColor
        let color2 = UIColor(red: 0.4, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1]
        self.view.layer.insertSublayer(gradientLayer,at: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
