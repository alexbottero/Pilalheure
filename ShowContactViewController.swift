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
