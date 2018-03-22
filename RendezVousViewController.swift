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
    
    @IBOutlet weak var rendezVousTable: UITableView!
    

    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
