//
//  AddMedicamentViewController.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class AddMedicamentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var nomMedicamentText: UITextField!
    @IBOutlet weak var doseMedicamentText: UITextField!
    @IBOutlet weak var unitePicker: UIPickerView!
    @IBOutlet weak var descriptionMedicamentText: UITextView!
    
    /// Donnée des unités de dose
    var pickerData : [String] = ["mL", "L", "g", "mg"]
    
    /// variables servant a récupérer la valeur selectionnée par le picker
    var selectedValues : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.unitePicker.delegate = self
        self.unitePicker.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Cancel and Save -
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Bouton de sauvegarde du médicament. Appel le constructeur de MedicamentDTO.
    /// - Pre-conditions : A besoin forcement d'un médicament
    /// - Parameter sender: Any
    @IBAction func saveAction(_ sender: Any) {
        let nom : String = self.nomMedicamentText.text ?? ""
        let dose : String = self.doseMedicamentText.text ?? ""
        let unite : String = self.selectedValues
        let description : String = self.descriptionMedicamentText.text ?? ""
        guard (nom != "") else {return}
        let medoc = Medicament(nom: nom, dose: dose, unite: unite, desc: description)
        MedicamentDTO.add(medicament: medoc)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - TextField Delegate -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Picker Functions -
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        selectedValues = pickerData[unitePicker.selectedRow(inComponent: 0)]
    }
    
}

