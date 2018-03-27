//
//  AddPrescriptionViewController.swift
//  Pilalheure
//
//  Created by Vincent Herreros on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class AddPrescriptionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK:-Variables-
    
    @IBOutlet weak var intervalleContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Background.color(controleur: self)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -Cancel and save-
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
            guard let embedIntervalleAddViewController = self.childViewControllers[0] as? IntervalleAddPrescriptionViewController
                else {return}
            let medoc : MedicamentDTO? = embedIntervalleAddViewController.selectedMedicament
            let dateDebutPicker : Date = embedIntervalleAddViewController.dateDebutPicker.date
            let dateFinPicker : Date = embedIntervalleAddViewController.dateFinPicker.date
            let heureDebutPicker : Date = embedIntervalleAddViewController.heureDebutPicker.date
            let heureFinPicker : Date? = embedIntervalleAddViewController.heureFinPicker.date
            let intervalle : String = embedIntervalleAddViewController.intervalleText.text!
            let number: Int64? = Int64(intervalle)
            guard let medoc2 = medoc else {return}
        
        //On regarde quel type de prescription il faut creer
            if(embedIntervalleAddViewController.heureDebutPickerText.text != ""){
                if(embedIntervalleAddViewController.heureFinPickerText.text != ""){
                    //creer la nouvelle prescription
                    let prescription = Prescription(medicament: medoc2, dateDebut: dateDebutPicker, dateFin: dateFinPicker, heureDebut: heureDebutPicker, heureFin: heureFinPicker, intervalle: number, heurePrecise: nil)
                    PrescriptionDTO.add(prescription: prescription)
                }
                else{
                    //creer la nouvelle prescription
                    let prescription = Prescription(medicament: medoc2, dateDebut: dateDebutPicker, dateFin: dateFinPicker, heureDebut: heureDebutPicker, heureFin: nil, intervalle: number, heurePrecise: nil)
                    PrescriptionDTO.add(prescription: prescription)
                }
            }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - TextField Delegate -
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
