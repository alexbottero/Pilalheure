//
//  ShowPrescriptionViewController.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 22/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData

class ShowPrescriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var rappelTable: UITableView!
    
    var prescription : PrescriptionDTO? = nil

    /// Récupère tous les médicaments contenu dans le CoreData
    fileprivate lazy var rappelFetched : NSFetchedResultsController<RappelDTO> = {
        //préparation de la requete
        let request : NSFetchRequest<RappelDTO> = RappelDTO.fetchRequest()
        //Ajout d'un tri sur la requete : trie pat les noms de médicaments
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(RappelDTO.dateRappel), ascending:true)]
        let predicate = NSPredicate(format:"events.prescriptions.medicaments.nom = %@", (self.prescription?.medicaments?.nom)!)
        request.predicate = predicate
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do{
            try self.rappelFetched.performFetch()
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
        let cell = self.rappelTable.dequeueReusableCell(withIdentifier: "rappelCell", for: indexPath) as! ShowPrescriptionTableViewCell
        let rappel = self.rappelFetched.object(at: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let stringDate = dateFormatter.string(from: rappel.dateRappel! as Date)
        cell.dateLabel.text = stringDate
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.rappelFetched.sections?[section] else{
            fatalError("enexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }

    
}
