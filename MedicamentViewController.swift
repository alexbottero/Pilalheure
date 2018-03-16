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
            DialogBoxHelper.alert(view: self, error: error)
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
        let medoc = self.medicamentsFetched.object(at: indexPath)
        CoreDataManager.context.delete(medoc)
        /*self.medicamentTable.beginUpdates()
        if self.delete(medicamentWithIndex: indexPath.row){
            self.medicamentTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        self.medicamentTable.endUpdates()
        self.medicamentTable.setEditing(false, animated: true)*/
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: self.deleteHandlerAction)
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    //MARK: - TableView delegate protocol -
    
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: segueShowMedicamentId, sender: self)
    }
    
    //MARK: - Medicaments data management -
    
    
    func save(){
        if let error=CoreDataManager.save(){
            DialogBoxHelper.alert(view: self, error: error)
        }
    }
    
    /// fonction de sauvegarde des medicaments
    ///
    /// - Parameters:
    ///   - name: nom du medicament
    ///   - dose: dose du medicament
    ///   - unite: unite du medicament
    ///   - description: description donnée pour le médicament
    
    func saveNewMedicament(withName name: String, withDose dose: String, withUnite unite: String, withDescription description: String){
        let context = CoreDataManager.context
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
            DialogBoxHelper.alert(view: self, error: error)
            return
        }
    }
    
    /*func delete(medicamentWithIndex index: Int) -> Bool{
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
    }*/
    
    //MARK: - NSFetchedResult delegate protocol -
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.medicamentTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.medicamentTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.medicamentTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.medicamentTable.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    let segueShowMedicamentId = "showMedicamentSegue"
    
    // MARK: - Navigation -
    
    //passage des informations à la page suivante
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowMedicamentId{
            if let indexPath = self.medicamentTable.indexPathForSelectedRow{
                let showMedicamentViewController = segue.destination as! ShowMedicamentViewController
                showMedicamentViewController.medicament = self.medicamentsFetched.object(at: indexPath)
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

