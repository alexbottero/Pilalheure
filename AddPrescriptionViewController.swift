//
//  AddPrescriptionViewController.swift
//  Pilalheure
//
//  Created by Vincent Herreros on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class AddPrescriptionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var precisContainerView: UIView!
    @IBOutlet weak var intervalleContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if(self.intervalleContainerView.alpha == 1){
            guard let embedIntervalleAddViewController = self.childViewControllers[1] as? IntervalleAddPrescriptionViewController
                else {return}
            let medoc : MedicamentDTO? = embedIntervalleAddViewController.selectedMedicament
            let dateDebutPicker : Date = embedIntervalleAddViewController.dateDebutPicker.date
            let dateFinPicker : Date = embedIntervalleAddViewController.dateFinPicker.date
            let heureDebutPicker : Date = embedIntervalleAddViewController.heureDebutPicker.date
            let heureFinPicker : Date = embedIntervalleAddViewController.heureFinPicker.date
            let intervalle : String = embedIntervalleAddViewController.intervalleText.text!
            let number: Int64? = Int64(intervalle)
            guard let medoc2 = medoc else {return}
            let prescription = Prescription(medicament: medoc2, dateDebut: dateDebutPicker, dateFin: dateFinPicker, heureDebut: heureDebutPicker, heureFin: heureFinPicker, intervalle: number, heurePrecise: nil)
            PrescriptionDTO.add(prescription: prescription)
        }
        else {
            guard let embedPrecisAddViewController = self.childViewControllers[0] as? PrecisAddPrescriptionViewController
                else {return}
            let medoc : MedicamentDTO? = embedPrecisAddViewController.selectedMedicament
            let dateDebutPicker : Date = embedPrecisAddViewController.dateDebutPicker.date
            let dateFinPicker : Date = embedPrecisAddViewController.dateFinPicker.date
            let heurePrecise : Date = embedPrecisAddViewController.heurePrecisePicker.date
            guard let medoc2 = medoc else {return}
            let prescription = Prescription(medicament: medoc2, dateDebut: dateDebutPicker, dateFin: dateFinPicker, heureDebut: nil, heureFin: nil, intervalle: nil, heurePrecise: heurePrecise)
            PrescriptionDTO.add(prescription: prescription)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - TextField Delegate -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func showComponents(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.intervalleContainerView.alpha = 1
                self.precisContainerView.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.intervalleContainerView.alpha = 0
                self.precisContainerView.alpha = 1
            })
        }
    }
    
}
