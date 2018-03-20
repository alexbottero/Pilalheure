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
            let medoc : MedicamentDTO = embedIntervalleAddViewController.selectedMedicament!
            let dateDebutPicker : Date = embedIntervalleAddViewController.dateDebutPicker.date
            /*let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let stringDate = dateFormatter.string(from: datePicker as Date)
            print(stringDate)*/
            let dateFinPicker : Date = embedIntervalleAddViewController.dateFinPicker.date
            let heureDebutPicker : Date = embedIntervalleAddViewController.heureDebutPicker.date
            let heureFinPicker : Date = embedIntervalleAddViewController.heureFinPicker.date
            let intervalle : String = embedIntervalleAddViewController.intervalleText.text!
            guard (medoc != nil) else {return}
            let prescription = Prescription(medicament: medoc, dateDebut: dateDebutPicker, dateFin: dateFinPicker, heureDebut: heureDebutPicker, heureFin: heureFinPicker, intervalle: intervalle, heurePrecise: nil)
            PrescriptionDTO.add(prescription: prescription)
        }
        else {
            guard let embedPrecisAddViewController = self.childViewControllers[0] as? PrecisAddPrescriptionViewController
                else {return}
            let medoc : String = embedPrecisAddViewController.medicamentPickerText.text ?? ""
            guard (medoc != "") else {return}
            let prescription = PrescriptionDTO(context: CoreDataManager.context)
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
