//
//  ShowMedicamentViewController.swift
//  Pilalheure
//
//  Created by Sheena Maucuer on 14/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData

class ShowMedicamentViewController: UIViewController {
    
    @IBOutlet weak var nomMedicamentLabel: UILabel!
    @IBOutlet weak var doseMedicamentLabel: UILabel!
    @IBOutlet weak var unieMedicamentLabel: UILabel!
    @IBOutlet weak var descriptionMedicamenLabel: UILabel!
    
    var medicament : MedicamentDAO? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let medoc = self.medicament{
            self.nomMedicamentLabel.text = medoc.nom
            self.doseMedicamentLabel.text = medoc.dose
            self.unieMedicamentLabel.text = medoc.unite
            self.descriptionMedicamenLabel.text = medoc.descript
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

