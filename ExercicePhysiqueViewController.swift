//
//  ExercicePhysiqueTableViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 14/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData


class ExercicePhysiqueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    
    //MARK:-Variables-
    @IBOutlet weak var exercicePhysiqueTable: UITableView!
    /// Variable récupérant les exercicesPhysiques grâce au fecth
    fileprivate lazy var exercicePhysiqueFetched : NSFetchedResultsController<ExercicePhysiqueDTO> = {
        let request : NSFetchRequest <ExercicePhysiqueDTO> = ExercicePhysiqueDTO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(ExercicePhysiqueDTO.nom),ascending:true)]
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName:nil)
        fetchResultController.delegate =  self
        return fetchResultController
    }()
    
    /// Presenter
     @IBOutlet var exPresenter : ExercicePhysiquePresenter!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Background.color(controleur: self)

        do{
            try self.exercicePhysiqueFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -Delete-
    
    func deleteHandlerAction(action: UITableViewRowAction,indexPath: IndexPath) -> Void {
        let exPhys = self.exercicePhysiqueFetched.object(at: indexPath)
        ExercicePhysiqueDTO.delete(exPhys: exPhys)
    }
    
    
    
    
    // MARK: - Table view data source -
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Del", handler: self.deleteHandlerAction)
        delete.backgroundColor = UIColor.red
        return [delete]
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.exercicePhysiqueTable.dequeueReusableCell(withIdentifier: "exercicePhysiqueCell", for: indexPath) as! ExercicePhysiqueTableViewCell
        //self.exPresenter.configure(theCell: cell, forExercicePhysique: self.exercicePhysique[indexPath.row])
        let exPhys = self.exercicePhysiqueFetched.object(at: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let stringDate = dateFormatter.string(from: exPhys.date! as Date)
        //self.exPresenter.configure(theCell: cell, forExercicePhysique: exPhys)
        cell.nomExercicePhysique.text = exPhys.nom
        cell.dateExercicePhysique.text = stringDate
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.exercicePhysiqueFetched.sections?[section]else{
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }
    
    
    // MARK: - Navigation
    let segueShowExPhysId = "ShowExPhysSegue"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowExPhysId{
            if let indexPath = self.exercicePhysiqueTable.indexPathForSelectedRow{
                let showExercicePhysiqueViewController = segue.destination as! ShowExercicePhysiqueViewController
                showExercicePhysiqueViewController.exPhys = self.exercicePhysiqueFetched.object(at: indexPath)
                self.exercicePhysiqueTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    
    
    // - NSFetchResultController delegate protocol
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.exercicePhysiqueTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.exercicePhysiqueTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.exercicePhysiqueTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.exercicePhysiqueTable.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
   
}

