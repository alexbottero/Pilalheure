//
//  RendezVousAddViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 22/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData


class RendezVousAddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var heureFinField: UITextField!
    @IBOutlet weak var labelHeureFin: UILabel!
    @IBOutlet weak var heureDebutField: UITextField!
    @IBOutlet weak var labelHeureDebut: UILabel!
    @IBOutlet weak var dateRDV: UIDatePicker!
    @IBOutlet weak var contactPickerText: UITextField!
    var data = [ContactDTO]()
    let managedObjectContext = CoreDataManager.context
    
    var selectedContact : ContactDTO? = nil
    var contactPicker = UIPickerView()
    
    let heureDebutPicker = UIDatePicker()
    let heureFinPicker = UIDatePicker()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker(Picker: heureDebutPicker, textPicker: heureDebutField, debOuFin: true)
         createDatePicker(Picker: heureFinPicker, textPicker: heureFinField, debOuFin: false)
        // Do any additional setup after loading the view.
        fetchData()
        contactPicker.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Contact Picker function -
    
    func fetchData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactDTO")
        if let fetchResults = try? managedObjectContext.fetch(fetchRequest) as? [ContactDTO]{
            data = fetchResults!
        }
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.contactPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.contactPicker.delegate = self
        self.contactPicker.dataSource = self
        self.contactPicker.backgroundColor = UIColor.white
        textField.inputView = self.contactPicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RendezVousAddViewController.doneClick))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    func doneClick() {
        contactPickerText.resignFirstResponder()
    }
    func cancelClick() {
        contactPickerText.resignFirstResponder()
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
        selectedContact = oneData
        if (selectedContact?.profession == "neurologue"){
            labelHeureDebut.isHidden = false
            labelHeureFin.isHidden = false
            heureDebutField.isHidden = false
            heureFinField.isHidden = false
        }
        else{
            labelHeureDebut.isHidden = true
            labelHeureFin.isHidden = true
            heureDebutField.isHidden = true
            heureFinField.isHidden = true
        }
        return (oneData.nom)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.contactPickerText.text = data[row].nom
    }
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(contactPickerText)
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func saveAction(_ sender: Any) {
        let rdv : String = self.contactPickerText.text ?? ""
        let date : Date = self.dateRDV.date
        let heureDeb : Date = self.heureDebutPicker.date
        let heureFin : Date = self.heureFinPicker.date
        print(date)
        guard (rdv != "") else {return}
        if (selectedContact?.profession == "neurologue"){
            let rendezVous = RendezVous(date: date, contact: selectedContact!,heureDeb:heureDeb, heureFin:heureFin)
             RendezVousDTO.add(rendezVous : rendezVous)
            
        }
        else{
            let rendezVous = RendezVous(date: date, contact: selectedContact!,heureDeb:nil, heureFin:nil)
             RendezVousDTO.add(rendezVous : rendezVous)
        }
       
        self.dismiss(animated: true, completion: nil)

    }
    //MARK : Gestion heures Picker
    
    
    func donePressedHeureDeb(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "fr_FR")
        heureDebutField.text = dateFormatter.string(from: heureDebutPicker.date)
        self.view.endEditing(true)
    }
    
    func donePressedHeureFin(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "fr_FR")
        heureFinField.text = dateFormatter.string(from: heureFinPicker.date)
        self.view.endEditing(true)
    }
    
    func createDatePicker(Picker picker : UIDatePicker, textPicker text : UITextField, debOuFin value : Bool){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        picker.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        picker.datePickerMode = .time
        if(value){
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedHeureDeb))
            toolbar.setItems([doneButton], animated: false)
            text.inputAccessoryView = toolbar
            }
        else{
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedHeureFin))
            toolbar.setItems([doneButton], animated: false)
            text.inputAccessoryView = toolbar
            }
        text.inputView = picker
    }
    
}
