//
//  PrecisAddPrescriptionViewController.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 16/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData

class PrecisAddPrescriptionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var dateDebutPickerText: UITextField!
    @IBOutlet weak var heurePrecisePickerText: UITextField!
    @IBOutlet weak var dateFinPickerText: UITextField!
    @IBOutlet weak var medicamentPickerText: UITextField!
    let managedObjectContext = CoreDataManager.context
    var data : [MedicamentDTO] = []
    var medicamentPicker = UIPickerView()
    let dateDebutPicker = UIDatePicker()
    let dateFinPicker = UIDatePicker()
    let heurePrecisePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createDatePicker(datePicker: dateDebutPicker, textPicker: dateDebutPickerText, debOuFin: true, dateOuHeure: true)
        createDatePicker(datePicker: dateFinPicker, textPicker: dateFinPickerText, debOuFin: false, dateOuHeure: true)
        createDatePicker(datePicker: heurePrecisePicker, textPicker: heurePrecisePickerText, debOuFin: true, dateOuHeure: false)
        fetchData()
        medicamentPicker.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Medicament Picker function -
    
    func fetchData(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MedicamentDTO")
        if let fetchResults = try? managedObjectContext.fetch(fetchRequest) as? [MedicamentDTO]{
            data = fetchResults!
        }
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.medicamentPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.medicamentPicker.delegate = self
        self.medicamentPicker.dataSource = self
        self.medicamentPicker.backgroundColor = UIColor.white
        textField.inputView = self.medicamentPicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(IntervalleAddPrescriptionViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(IntervalleAddPrescriptionViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    func doneClick() {
        medicamentPickerText.resignFirstResponder()
    }
    func cancelClick() {
        medicamentPickerText.resignFirstResponder()
    }
    
    //MARK:- Date Picker function -
    
    
    func createDatePicker(datePicker picker : UIDatePicker, textPicker text : UITextField, debOuFin value : Bool, dateOuHeure val : Bool){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        picker.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        if(val){
            picker.datePickerMode = .date
            if(value){
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedDateDeb))
                toolbar.setItems([doneButton], animated: false)
                text.inputAccessoryView = toolbar
            }
            else{
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedDateFin))
                toolbar.setItems([doneButton], animated: false)
                text.inputAccessoryView = toolbar
            }
        }
        else{
            picker.datePickerMode = .time
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedHeurePrecise))
            toolbar.setItems([doneButton], animated: false)
            text.inputAccessoryView = toolbar
        }
        
        text.inputView = picker
    }
    
    func donePressedDateDeb(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateDebutPickerText.text = dateFormatter.string(from: dateDebutPicker.date)
        self.view.endEditing(true)
    }
    
    func donePressedDateFin(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFinPickerText.text = dateFormatter.string(from: dateFinPicker.date)
        self.view.endEditing(true)
    }
    
    func donePressedHeurePrecise(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "fr_FR")
        heurePrecisePickerText.text = dateFormatter.string(from: heurePrecisePicker.date)
        self.view.endEditing(true)
    }
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.fetchData()
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let oneData = data[row]
        return (oneData.nom)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.medicamentPickerText.text = data[row].nom
    }
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(medicamentPickerText)
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
