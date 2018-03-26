//
//  QuestionnaireRendezVousViewController.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 26/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData

class QuestionnaireRendezVousViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var questionnaireRendezVousTable: UITableView!
    
    fileprivate lazy var rendezVousFetched : NSFetchedResultsController<RendezVousDTO> = {
        //prepare request
        let request : NSFetchRequest<RendezVousDTO> = RendezVousDTO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(RendezVousDTO.date), ascending:true)]
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source protocol -
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let cell = self.questionnaireRendezVousTable.dequeueReusableCell(withIdentifier: "questionnaireRendezVousCell", for: indexPath) as! QuestionnaireRendezVousTableViewCell
            //self.exPresenter.configure(theCell: cell, forExercicePhysique: self.exercicePhysique[indexPath.row])
            let rendezVous = self.rendezVousFetched.object(at: indexPath)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let stringDate = dateFormatter.string(from: rendezVous.date! as Date)
            //self.exPresenter.configure(theCell: cell, forExercicePhysique: exPhys)
            cell.nomDocteur.text = rendezVous.contacts?.nom
            cell.dateRendezVous.text = stringDate
            return cell
            
        }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.rendezVousFetched.sections?[section] else{
            fatalError("enexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void{
        let rendezVous = self.rendezVousFetched.object(at: indexPath)
        RendezVousDTO.delete(rendezVous: rendezVous)
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: self.deleteHandlerAction)
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    //MARK: - TableView delegate protocol -
    
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: segueShowRendezVousId, sender: self)
    }
    
    
    //MARK: - NSFetchedResult delegate protocol -
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.questionnaireRendezVousTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.questionnaireRendezVousTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.questionnaireRendezVousTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.questionnaireRendezVousTable.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    
    // MARK: - Navigation -
    
    let segueShowRendezVousId = "showRendezVousSegue"
    
    //passage des informations à la page suivante
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowRendezVousId{
            if let indexPath = self.questionnaireRendezVousTable.indexPathForSelectedRow{
                let questionnaireViewController = segue.destination as! QuestionnaireViewController
                questionnaireViewController.rendezVous = self.rendezVousFetched.object(at: indexPath)
                self.questionnaireRendezVousTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }


}
