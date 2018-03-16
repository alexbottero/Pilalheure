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
    
    @IBOutlet var medicamentPresenter: MedicamentPresenter!
    
    var medicaments : [MedicamentDAO] = []
    
    fileprivate lazy var medicamentsFetched : NSFetchedResultsController<MedicamentDAO> = {
     //prepare request
     let request : NSFetchRequest<MedicamentDAO> = MedicamentDAO.fetchRequest()
     request.sortDescriptors = [NSSortDescriptor(key:#keyPath(MedicamentDAO.nom), ascending:true)]
     let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
     fetchResultController.delegate = self
     return fetchResultController
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do{
            try self.medicamentsFetched.performFetch()
        }
        catch let error as NSError{
            self.alert(error: error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source protocol -
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.medicamentTable.dequeueReusableCell(withIdentifier: "medicamentCell", for: indexPath) as! MedicamentTableViewCell
        let medoc = self.medicamentsFetched.object(at: indexPath)
        self.medicamentPresenter.configure(theCell: cell, forMedicament: medoc)
        cell.accessoryType = .detailButton
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.medicamentsFetched.sections?[section] else{
            fatalError("enexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void{
        self.medicamentTable.beginUpdates()
        if self.delete(medicamentWithIndex: indexPath.row){
            self.medicamentTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        self.medicamentTable.endUpdates()
        self.medicamentTable.setEditing(false, animated: true)
    }
    
    func editHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void{
        print("edit")
        self.medicamentTable.setEditing(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Del", handler: self.deleteHandlerAction)
        let edit = UITableViewRowAction(style: .default, title: "Edit", handler: self.editHandlerAction)
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        return [delete, edit]
    }
    
    //MARK: - TableView delegate protocol -
    
    var indexPathForShow : IndexPath? = nil
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: segueShowMedicamentId, sender: self)
    }
    
    //MARK: - Medicaments data management -
    
    /// fonction de sauvegarde des medicaments
    ///
    /// - Parameters:
    ///   - name: nom du medicament
    ///   - dose: dose du medicament
    ///   - unite: unite du medicament
    ///   - description: description donnée pour le médicament
    func saveNewMedicament(withName name: String, withDose dose: String, withUnite unite: String, withDescription description: String){
        guard let context = getContext(errorMsg: "Save failed") else {return}
        let medoc = MedicamentDAO(context: context)
        medoc.nom = name
        medoc.dose = dose
        medoc.unite = unite
        medoc.descript = description
        do{
            try context.save()
            self.medicaments.append(medoc)
        }
        catch let error as NSError{
            self.alert(error: error)
            return
        }
    }
    
    func delete(medicamentWithIndex index: Int) -> Bool{
        guard let context = getContext(errorMsg: "Could not delee Medicament") else { return false}
        let medoc = self.medicaments[index]
        context.delete(medoc)
        do{
            try context.save()
            self.medicaments.remove(at: index)
            return true
        }
        catch let error as NSError{
            self.alert(error: error)
            return false
        }
    }
    
    
    // MARK: - Helper Methods
    
    /// Récupère le context d'un Core Data initialisé dans l'application delegate
    ///
    /// - Parameters:
    ///   - errorMsg: Message d'erreur
    ///   - userInfoMsg: Information additionnelle
    /// - Returns: Retourne le context d'un Core Data
    func getContext(errorMsg: String, userInfoMsg: String = "could not retrieve data context") -> NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.alert(WithTitle: errorMsg, andMessage: userInfoMsg)
            return nil
        }
        return appDelegate.persistentContainer.viewContext
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
    
    let segueShowMedicamentId = "showMedicamentSegue"
    
    // MARK: - Navigation -
    
    //passage des informations à la page suivante
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowMedicamentId{
            if let indexPath = self.indexPathForShow{
                let showMedicamentViewController = segue.destination as! ShowMedicamentViewController
                showMedicamentViewController.medicament = self.medicaments[indexPath.row]
                self.medicamentTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindToMedicamentsListAfterSavingNewMedicament(segue: UIStoryboardSegue){
        let newMedicamentController = segue.source as! AddMedicamentViewController
        //let doseInt : Int32 = Int32(newMedicamentController.doseMedicamentText.text!)!
        //let medoc = Medicament(nom: newMedicamentController.nomMedicamentText.text!, dose: doseInt, unite: newMedicamentController.selectedValues, desc: newMedicamentController.descriptionMedicamentText.text)
        self.saveNewMedicament(withName: newMedicamentController.nomMedicamentText.text!, withDose: newMedicamentController.doseMedicamentText.text!, withUnite: newMedicamentController.selectedValues, withDescription: newMedicamentController.descriptionMedicamentText.text!)
        self.medicamentTable.reloadData()
    }
    
}

