//
//  ShowContactViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 19/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class ShowContactViewController: UIViewController {
    
    var contact : ContactDTO?=nil
    
    //MARK: -Variables-
    @IBOutlet weak var mailField: UILabel!
    @IBOutlet weak var professionField: UILabel!
    @IBOutlet weak var nomField: UILabel!
    @IBOutlet weak var telField: UILabel!
    @IBOutlet weak var adresseField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contact = self.contact{
            self.mailField.text = contact.nom
            self.telField.text = contact.telephone
            self.adresseField.text = contact.adresse
            self.nomField.text = contact.nom
            self.professionField.text = contact.profession
        }
        Background.color(controleur: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
