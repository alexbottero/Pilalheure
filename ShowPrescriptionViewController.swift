//
//  ShowPrescriptionViewController.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 22/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData

class ShowPrescriptionViewController: UIViewController {
    
    var prescription : PrescriptionDTO? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        if let prescri = self.prescription{
            print("hello")
            if let date = prescri.events?.rappels{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy 'at' HH:mm"
                for d in date{
                    if let da = d as? RappelDTO{
                        let stringDate = dateFormatter.string(from: da.dateRappel as! Date)
                        print(stringDate)
                    }
                }
            }
        }
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
