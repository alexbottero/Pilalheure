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
    
    
    // MARK : - Variables-

    /// Table contenant les médicaments
    @IBOutlet weak var medicamentTable: UITableView!
    
    /// Presenter de la cellule médicament
    @IBOutlet var medicamentPresenter: MedicamentPresenter!
    /// Récupère tous les médicaments contenu dans le CoreData
    
    fileprivate lazy var medicamentsFetched : NSFetchedResultsController<MedicamentDTO> = {
        //préparation de la requete
        let request : NSFetchRequest<MedicamentDTO> = MedicamentDTO.fetchRequest()
        //Ajout d'un tri sur la requete : trie pat les noms de médicaments
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(MedicamentDTO.nom), ascending:true)]
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
        Background.color(controleur: self)
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
    
    // MARK: - Table View Handler Action -
    
    /// Function de suppression des médicaments. Appelle la fonction delete du DAO
    ///
    /// - Parameters:
    ///   - action: UITableViewRowAction
    ///   - indexPath: IndexPath
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void{
        let medoc = self.medicamentsFetched.object(at: indexPath)
        MedicamentDTO.delete(medicament : medoc)
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
    
    
    // MARK: - Navigation -
    
    /// Id du la page show de médicament
    let segueShowMedicamentId = "showMedicamentSegue"

    /// Passage des informations de la cellule à la page suivante Show
    ///
    /// - Parameters:
    ///   - segue: UIStoryboardSegue
    ///   - sender: Any?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowMedicamentId{
            if let indexPath = self.medicamentTable.indexPathForSelectedRow{
                let showMedicamentViewController = segue.destination as! ShowMedicamentViewController
                showMedicamentViewController.medicament = self.medicamentsFetched.object(at: indexPath)
                self.medicamentTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    
}

