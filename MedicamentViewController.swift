//
//  MedicamentViewController.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData

class MedicamentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{
    
    
    @IBOutlet weak var medicamentTable: UITableView!
    var medicaments : [Medicament] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source protocol -
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.medicamentTable.dequeueReusableCell(withIdentifier: "medicamentCell", for: indexPath) as! MedicamentTableViewCell
        cell.nom.text = self.medicaments[indexPath.row].nom
        cell.dose.text = String(self.medicaments[indexPath.row].dose)
        cell.unite.text = self.medicaments[indexPath.row].unite
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.medicaments.count
    }
    
    /// Fait apparaître une boite de dialogue "alert" avec 2 messages
    ///
    /// - Parameters:
    ///   - title: Titre de la boite de dialogue
    ///   - msg: Message de la boite de dialogue
    func alert(WithTitle title: String, andMessage msg: String = ""){
        let alert = UIAlertController(title: title,
                                      message: msg,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .default)
        alert.addAction(cancelAction)
        present(alert,animated: true)
    }
    
    /// Fait apparaître une boite de dialogue lorsqu'il y a une erreur.
    ///
    /// - Parameter error: Erreur donné à la boite de dialogue
    func alert(error: NSError){
        self.alert(WithTitle:"\(error)", andMessage: "\(error.userInfo)")
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
     // MARK: - Navigation -
     
    @IBAction func unwindToMedicamentsListAfterSavingNewMedicament(segue: UIStoryboardSegue){
        let newMedicamentController = segue.source as! AddMedicamentViewController
        let medoc = Medicament(nom: newMedicamentController.nomMedicamentText.text!, dose: newMedicamentController.doseMedicamentText.text!, unite: newMedicamentController.selectedValues, desc: newMedicamentController.descriptionMedicamentText.text)
        medicaments.append(medoc)
    }
    
}
