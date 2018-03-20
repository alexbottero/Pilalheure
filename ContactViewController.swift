//
//  ContactViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 19/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData


class ContactViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var contactTable: UITableView!
    
    fileprivate lazy var contactFetched : NSFetchedResultsController<ContactDTO> = {
        let request : NSFetchRequest <ContactDTO> = ContactDTO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(ContactDTO.nom),ascending:true)]
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName:nil)
        fetchResultController.delegate =  self
        return fetchResultController
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.contactFetched.sections?[section]else{
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.contactTable.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        //self.exPresenter.configure(theCell: cell, forExercicePhysique: self.exercicePhysique[indexPath.row])
        let cont = self.contactFetched.object(at: indexPath)
        //self.exPresenter.configure(theCell: cell, forExercicePhysique: exPhys)
        cell.nomContact.text = cont.nom
        return cell
        
    }
    

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try self.contactFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func deleteHandlerAction(action: UITableViewRowAction,indexPath: IndexPath) -> Void {
        //self.exercicePhysiqueTable.beginUpdates()
        let contact = self.contactFetched.object(at: indexPath)
        ContactDTO.delete(cont: contact)
        /*
         if self.delete(exPhysWithIndex: indexPath.row){
         self.exercicePhysiqueTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
         }
         self.exercicePhysiqueTable.endUpdates()*/
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Del", handler: self.deleteHandlerAction)
        //let edit = UITableViewRowAction(style: .default, title: "edit",handler: self.editHandlerAction)
        delete.backgroundColor = UIColor.red
        //edit.backgroundColor = UIColor.blue
        // ajouter edit pour la modif
        return [delete]
        
    }
    // MARK: - Navigation
    let segueShowContactId = "ShowContactSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowContactId{
            if let indexPath = self.contactTable.indexPathForSelectedRow{
                let showContactViewController = segue.destination as! ShowContactViewController
                showContactViewController.contact = self.contactFetched.object(at: indexPath)
                self.contactTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    
    
    // - NSFetchResultController delegate protocol
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.contactTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.contactTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.contactTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.contactTable.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
}
