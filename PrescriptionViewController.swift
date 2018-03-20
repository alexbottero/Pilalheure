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
   
    @IBOutlet var prescriptionPresenter: PrescriptionPresenter!
    
    @IBOutlet weak var prescriptionTable: UITableView!
    
    fileprivate lazy var prescriptionFetched : NSFetchedResultsController<PrescriptionDAO> = {
        let request : NSFetchRequest<PrescriptionDAO> = PrescriptionDAO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(PrescriptionDAO.medicaments.nom), ascending: true)]
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
    
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void{
        let prescription = self.prescriptionFetched.object(at: indexPath)
        CoreDataManager.context.delete(prescription)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: self.deleteHandlerAction)
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    
    
    //MARK: - Medicaments data management -
    
    
    func save(){
        if let error=CoreDataManager.save(){
            DialogBoxHelper.alert(view: self, error: error)
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
