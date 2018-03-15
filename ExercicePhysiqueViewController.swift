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
    var exercicePhysique : [ExercicePhysiqueDAO] = []
    
    @IBOutlet var exPresenter : ExercicePhysiquePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func unwindToExercicePhysiqueListAfterSavingNewExercicePhysique(segue:UIStoryboardSegue){
        let newExercicePhysiqueController = segue.source as! AddExercicePhysiqueViewController
        let nom=newExercicePhysiqueController.nomNewExercicePhysique.text ?? ""
        //let desc=newExercicePhysiqueController.descNewExercicePhysique.text!
        let times=newExercicePhysiqueController.tempsNewExercicePhysique.text ?? ""
        let nbRep=newExercicePhysiqueController.nbRepNewExercicePhysique.text ?? ""
        
        self.saveNewExPhys(Nom: nom,  Temps: times, NbRep: nbRep)
       exercicePhysiqueTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK : - save et update
    
    func saveNewExPhys(Nom nom: String, Temps temps: String?, NbRep nbRep: String?){
        guard let context = self.getContext(errorMsg: "save failed") else { return }
        let exPhys = ExercicePhysiqueDAO(context: context)
        exPhys.nom = nom
        //exPhys.descript = descr
        exPhys.temps = temps
        exPhys.nbRepetition=nbRep
        do{
            try context.save()
            self.exercicePhysique.append(exPhys)
        }
        catch let error as NSError{
            self.alert(error: error)
            return
        }
    }
    
    func delete(exPhysWithIndex index: Int) -> Bool{
        guard let context = getContext(errorMsg: "Could not delete Medicament") else {
            return false
        }
        let exPhy = self.exercicePhysique[index]
        context.delete(exPhy)
        do{
            try context.save()
            self.exercicePhysique.remove(at: index)
            return true
        }
        catch let error as NSError{
            self.alert(error: error)
            return false
        }
    }
    func deleteHandlerAction(action: UITableViewRowAction,indexPath: IndexPath) -> Void {
        self.exercicePhysiqueTable.beginUpdates()
        if self.delete(exPhysWithIndex: indexPath.row){
            self.exercicePhysiqueTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        self.exercicePhysiqueTable.endUpdates()
    }
    func editHandlerAction(action: UITableViewRowAction,indexPath: IndexPath) -> Void {
        print("edit")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Del", handler: self.deleteHandlerAction)
        let edit = UITableViewRowAction(style: .default, title: "edit",handler: self.editHandlerAction)
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        return [delete, edit]
    }
    
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete){
            self.exercicePhysiqueTable.beginUpdates()
            if self.delete(exPhysWithIndex: indexPath.row){
                self.exercicePhysiqueTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            self.exercicePhysiqueTable.endUpdates()
        }
    }*/
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.exercicePhysiqueTable.dequeueReusableCell(withIdentifier: "exercicePhysiqueCell", for: indexPath) as! ExercicePhysiqueTableViewCell
        //self.exPresenter.configure(theCell: cell, forExercicePhysique: self.exercicePhysique[indexPath.row])
        
        cell.nomExercicePhysique.text = self.exercicePhysique[indexPath.row].nom
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercicePhysique.count
    }
    
    // MARK: - Navigation
    
    let segueShowExPhysId = "ShowExPhysSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowExPhysId{
            if let indexPath = self.exercicePhysiqueTable.indexPathForSelectedRow{
                let showExercicePhysiqueViewController = segue.destination as! ShowExercicePhysiqueViewController
                showExercicePhysiqueViewController.exPhys = self.exercicePhysique[indexPath.row]
                self.exercicePhysiqueTable.deselectRow(at: indexPath, animated: true)
            }
        }
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

