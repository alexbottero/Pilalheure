//
//  AddExercicePhysiqueViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 14/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class AddExercicePhysiqueViewController: UIViewController,UITextFieldDelegate {

    //MARK:-Variables-
    @IBOutlet weak var descNewExercicePhysique: UITextView!
    @IBOutlet weak var dateNewExercicePhysique: UIDatePicker!
    @IBOutlet weak var nomNewExercicePhysique: UITextField!
    var exercicePhysique: ExercicePhysique?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       Background.color(controleur: self)
        self.dateNewExercicePhysique.tintColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - cancel et save
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let nom : String = self.nomNewExercicePhysique.text ?? ""
        let desc : String = self.descNewExercicePhysique.text ?? ""
        let date : Date = self.dateNewExercicePhysique.date
        
        guard (nom != "") else {return}
        let exPhys = ExercicePhysique(nom: nom, descript: desc, date: date as NSDate)
        ExercicePhysiqueDTO.add(exPhys : exPhys)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
