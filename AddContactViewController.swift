//
//  AddContactViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 19/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    //MARK:-Variables-
    
    @IBOutlet weak var nomContact: UITextField!
    @IBOutlet weak var mailContact: UITextField!
    @IBOutlet weak var telContact: UITextField!
    @IBOutlet weak var adresseContact: UITextField!
    @IBOutlet weak var profContact: UIPickerView!
    var contact: Contact?
    var pickerData : [String] = [String]()
    var selectedValues : String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Background.color(controleur: self)
        self.profContact.delegate = self
        self.profContact.dataSource = self
        pickerData = ["chirugien", "neurologue", "kine", "généraliste"]
        self.profContact.setValue(UIColor.white, forKey: "textColor")
        // Do any additional setup after loading the view.
        Background.color(controleur: self)
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
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="OKAddContact"{
        }
    }*/
    
    // MARK: - cancel et save

    @IBAction func cancelAction(_ sender: Any) {
         self.dismiss(animated: true,completion: nil)
    }
    
    // ajoute le nouveau contact
    @IBAction func saveAction(_ sender: Any) {
        let nom : String = self.nomContact.text ?? ""
        let tel : String = self.telContact.text ?? ""
        let adresse : String = self.adresseContact.text ?? ""
        let prof: String = self.selectedValues
        let mail: String = self.mailContact.text ?? ""
        guard (nom != "") else {return}
        let cont = Contact(nom: nom, prof: prof, mail: mail, adresse: adresse, tel: tel)
        ContactDTO.add(cont: cont)
        self.dismiss(animated: true, completion: nil)
        
        
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
        selectedValues = pickerData[profContact.selectedRow(inComponent: 0)]
    }
}
