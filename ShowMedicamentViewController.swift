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
    @IBOutlet weak var descriptionMedicamentLabel: UITextView!
    @IBOutlet weak var uniteMedicamentLabel: UILabel!
    
    /// Variable contenant les informations de la cellule selectionnée.
    var medicament : MedicamentDTO? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Affection des informations sur les labels
        if let medoc = self.medicament{
            self.nomMedicamentLabel.text = medoc.nom
            self.doseMedicamentLabel.text = medoc.dose
            self.uniteMedicamentLabel.text = medoc.unite
            self.descriptionMedicamentLabel.text = medoc.descript
        }
        Background.color(controleur: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

