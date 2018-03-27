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
    
    fileprivate lazy var medicamentsFetched : NSFetchedResultsController<MedicamentDTO> = {
     //prepare request
     let request : NSFetchRequest<MedicamentDTO> = MedicamentDTO.fetchRequest()
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
    
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void{
        let medoc = self.medicamentsFetched.object(at: indexPath)
        //CoreDataManager.context.delete(medoc)
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
    
    let segueShowMedicamentId = "showMedicamentSegue"

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
    
    //test
    /*var dateComp:NSDateComponents = NSDateComponents()
    dateComp.year = 2015;
    dateComp.month = 06;
    dateComp.day = 03;
    dateComp.hour = 12;
    dateComp.minute = 55;
    dateComp.timeZone = NSTimeZone.systemTimeZone()
    
    var calender:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var date:NSDate = calender.dateFromComponents(dateComp)!
    
    var notification:UILocalNotification = UILocalNotification()
    notification.category = "Daily Quote"
    notification.alertBody = quoteBook.randomQuote()
    notification.fireDate = date
    notification.repeatInterval =
    
    UIApplication.sharedApplication().scheduleLocalNotification(notification)*/
    
}

