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
    
    var medicaments : [Medicament] = []
    
    /*fileprivate lazy var medicamentsFetched : NSFetchedResultsController<MedicamentDAO> = 	{
        //prepare request
        let request : NSFetchRequest<MedicamentDAO> = MedicamentDAO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(MedicamentDAO.nom), ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source protocol -
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.medicamentTable.dequeueReusableCell(withIdentifier: "medicamentCell", for: indexPath) as! MedicamentTableViewCell
        //self.medicamentPresenter.configure(theCell: cell, forMedicament: self.medicaments[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.medicaments.count
    }
    
    
    // MARK: - Helper Methods
    
    /// Récupère le context d'un Core Data initialisé dans l'application delegate
    ///
    /// - Parameters:
    ///   - errorMsg: Message d'erreur
    ///   - userInfoMsg: Information additionnelle
    /// - Returns: Retourne le context d'un Core Data
    func getContext(errorMsg: String, userInfoMsg: String = "could not retrieve data context") -> NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.alert(WithTitle: errorMsg, andMessage: userInfoMsg)
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    /// Fait apparaître une boite de dialogue "alert" avec 2 messages
    ///
    /// - Parameters:
    ///   - title: Titre de la boite de dialogue
    ///   - msg: Message de la boite de dialogue
    func alert(WithTitle title: String, andMessage msg: String = ""){
        let alert = UIAlertController(title: title,
                                      message: msg,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .default)
        alert.addAction(cancelAction)
        present(alert,animated: true)
    }
    
    /// Fait apparaître une boite de dialogue lorsqu'il y a une erreur.
    ///
    /// - Parameter error: Erreur donné à la boite de dialogue
    func alert(error: NSError){
        self.alert(WithTitle:"\(error)", andMessage: "\(error.userInfo)")
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    // MARK: - Navigation -
    
    @IBAction func unwindToMedicamentsListAfterSavingNewMedicament(segue: UIStoryboardSegue){
        let newMedicamentController = segue.source as! AddMedicamentViewController
        let medoc = Medicament(nom: newMedicamentController.nomMedicamentText.text!, dose: newMedicamentController.doseMedicamentText.text!, unite: newMedicamentController.selectedValues, desc: newMedicamentController.descriptionMedicamentText.text)
        medicaments.append(medoc)
        medicamentTable.reloadData()
    }
    
}
