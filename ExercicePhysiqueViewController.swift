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
    
    @IBOutlet weak var exercicePhysiqueTable: UITableView!

    fileprivate lazy var exercicePhysiqueFetched : NSFetchedResultsController<ExercicePhysiqueDTO> = {
        let request : NSFetchRequest <ExercicePhysiqueDTO> = ExercicePhysiqueDTO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(ExercicePhysiqueDTO.nom),ascending:true)]
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName:nil)
        fetchResultController.delegate =  self
        return fetchResultController
    }()
    
    // Presenter
     @IBOutlet var exPresenter : ExercicePhysiquePresenter!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Background.color(controleur: self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        do{
            try self.exercicePhysiqueFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func deleteHandlerAction(action: UITableViewRowAction,indexPath: IndexPath) -> Void {
        let exPhys = self.exercicePhysiqueFetched.object(at: indexPath)
        ExercicePhysiqueDTO.delete(exPhys: exPhys)
    }
    
    
    /*func editHandlerAction(action: UITableViewRowAction,indexPath: IndexPath) -> Void {
        print("edit")
    }*/
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Del", handler: self.deleteHandlerAction)
        //let edit = UITableViewRowAction(style: .default, title: "edit",handler: self.editHandlerAction)
        delete.backgroundColor = UIColor.red
        //edit.backgroundColor = UIColor.blue
        // ajouter edit pour la modif
        return [delete]
        
    }
    
    // MARK: - Table view data source
    
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
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

