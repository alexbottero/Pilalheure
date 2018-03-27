//
//  RendezVousViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 22/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData

class RendezVousViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    
    // MARK : - Variables -
    /// Table des rendez-vous
    @IBOutlet weak var rendezVousTable: UITableView!
    
    /// Bouton d'ajout d'evenement exceptionnel
    @IBAction func addEvent(_ sender: Any) {
        let alert = UIAlertController(title: "Nouvel événement",
                                      message: "Ajouter un événement",
                                      preferredStyle: .alert)
        // Ajoute un nouvel élément
        let saveAction = UIAlertAction(title: "Ajouter",
                                       style: .default)
        {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else{
                    return
            }
            
        }
        let cancelAction = UIAlertAction(title : "Annuler",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    /// Tableau de rendez- vous
    fileprivate lazy var rendezVousFetched : NSFetchedResultsController<RendezVousDTO> = {
        let request : NSFetchRequest<RendezVousDTO> = RendezVousDTO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(RendezVousDTO.date), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        do{
            try self.rendezVousFetched.performFetch()
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
        let cell = self.rendezVousTable.dequeueReusableCell(withIdentifier: "rdvCell", for: indexPath) as! RendezVousTableViewCell
        let rendezVous = self.rendezVousFetched.object(at: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let stringDate = dateFormatter.string(from: rendezVous.date! as Date)
        cell.RDV.text = rendezVous.contacts?.profession
        cell.date.text = stringDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Nouvel événement",
                                      message: "Ajouter un événement",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Ajouter",
                                       style: .default)
        {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else{
                    return
            }
            let rendezVous = self.rendezVousFetched.object(at: indexPath as IndexPath)
            EventExceptionnel(nom: nameToSave, date: Date(), rendezVous: rendezVous)
            CoreDataManager.save()
        }
        let cancelAction = UIAlertAction(title : "Annuler",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        self.rendezVousTable.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.rendezVousFetched.sections?[section] else{
            fatalError("enexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    
    /// Permet de supprimer l'objet a la ligne de l'indexPath
    ///
    /// - Parameters:
    ///   - action: UITableViewRowAction
    ///   - indexPath: IndexPath
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void{
        let rendezVous = self.rendezVousFetched.object(at: indexPath)
        RendezVousDTO.delete(rendezVous: rendezVous)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: self.deleteHandlerAction)
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    
    //MARK: - NSFetchedResult delegate protocol -
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.rendezVousTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.rendezVousTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.rendezVousTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.rendezVousTable.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
    

}
