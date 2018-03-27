//
//  QuestionnaireViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 21/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class QuestionnaireViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, 
NSFetchedResultsControllerDelegate{
    
    var rendezVous : RendezVousDTO? = nil
    
    var data : [QuestionnaireDTO]? = nil
    var dataTri : [QuestionnaireDTO]? = nil
    
    var startOfDay: Date{
        return Calendar.current.startOfDay(for:Date())
    }
    let jourAvant: Int = 1
    
    
    @IBAction func switchJour(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                
            })
        }
    }
    
    
    
    @IBOutlet weak var jourQuest: UISegmentedControl!
    
    @IBOutlet weak var QuestionnaireTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = CoreDataManager.context
        let request : NSFetchRequest<QuestionnaireDTO> = QuestionnaireDTO.fetchRequest()
        //let predicate = NSPredicate(format:"rendezVousQuestS.contacts.nom = %@",(self.rendezVous?.contacts?.nom)!)
        //request.predicate = predicate
        print(rendezVous)
        do{
            try self.data = context.fetch(request)
        }catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
        Background.color(controleur: self)
        // Do any additional setup after loading the view.
        for i in data!{
            print(i.rendezVousQuestS)
            print(rendezVous)
            if(i.rendezVousQuestS?.date == rendezVous?.date){
                dataTri?.append(i)

            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source protocol -
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.QuestionnaireTable.dequeueReusableCell(withIdentifier: "questCell", for: indexPath) as! QuestionnaireTableViewCell
        let quest = self.dataTri?[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let stringDate = dateFormatter.string(from: quest?.date as! Date)
        cell.etat.text = quest?.etat
        cell.date.text = stringDate
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let c = self.dataTri?.count{
            return c
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    // - NSFetchResultController delegate protocol
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.QuestionnaireTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.QuestionnaireTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                self.QuestionnaireTable.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    // MARK: - notif
    /*
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
