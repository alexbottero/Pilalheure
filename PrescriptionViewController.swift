//
//  PrescriptionViewController.swift
//  Pilalheure
//
//  Created by Vincent Herreros on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData

class PrescriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
   
    //MARK:-Variables-
    @IBOutlet var prescriptionPresenter: PrescriptionPresenter!
    @IBOutlet weak var prescriptionTable: UITableView!
    
    fileprivate lazy var prescriptionFetched : NSFetchedResultsController<PrescriptionDTO> = {
        let request : NSFetchRequest<PrescriptionDTO> = PrescriptionDTO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(PrescriptionDTO.medicaments.nom), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do{
            try self.prescriptionFetched.performFetch()
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
        let cell = self.prescriptionTable.dequeueReusableCell(withIdentifier: "prescriptionCell", for: indexPath) as! PrescriptionTableViewCell
        let prescription = self.prescriptionFetched.object(at: indexPath)
        self.prescriptionPresenter.configure(theCell: cell, forPrescription: prescription)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.prescriptionFetched.sections?[section] else{
            fatalError("enexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: self.deleteHandlerAction)
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: segueShowPrescriptionId, sender: self)
    }
    
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void{
        let prescription = self.prescriptionFetched.object(at: indexPath)
        PrescriptionDTO.delete(prescription: prescription)
    }
    
    //MARK: - NSFetchedResult delegate protocol -
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.prescriptionTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.prescriptionTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.prescriptionTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.prescriptionTable.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
    

    // MARK: - Navigation

    let segueShowPrescriptionId = "showPrescriptionSegue"
    
    //passage des informations à la page suivante
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowPrescriptionId{
            if let indexPath = self.prescriptionTable.indexPathForSelectedRow{
                let showPrescriptionViewController = segue.destination as! ShowPrescriptionViewController
                showPrescriptionViewController.prescription = self.prescriptionFetched.object(at: indexPath)
                self.prescriptionTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }

}
