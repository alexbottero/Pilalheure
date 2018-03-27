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
    
    @IBAction func notif() {
        let date = Date().addingTimeInterval(5)
        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(runCode), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    func runCode(){
        let content = UNMutableNotificationContent()
        content.title = " Questionnaire d'etat"
        content.subtitle = " rendez vous chez le neurologue proche"
        content.body = " Quel est votre état ?"
        content.badge = 1
        content.categoryIdentifier = "questCat"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let requestIdentifier = "EtatQuestionnaire"
        
        let request=UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in
        })
    }
    
    @IBOutlet weak var jourQuest: UISegmentedControl!
    
    @IBOutlet weak var QuestionnaireTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = CoreDataManager.context
        let request : NSFetchRequest<QuestionnaireDTO> = QuestionnaireDTO.fetchRequest()
        let predicate = NSPredicate(format:"rendezVousQuestS.contacts.nom",(self.rendezVous?.contacts?.nom)!)
        request.predicate = predicate
        do{
            try self.data = context.fetch(request)
        }catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
        UNUserNotificationCenter.current().delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source protocol -
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.QuestionnaireTable.dequeueReusableCell(withIdentifier: "questCell", for: indexPath) as! QuestionnaireTableViewCell
        let quest = self.data?[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let stringDate = dateFormatter.string(from: quest?.date! as! Date)
        cell.etat.text = quest?.etat
        cell.date.text = stringDate
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (self.data?.count)!
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
extension QuestionnaireViewController: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "reponse1":
            let date = Date()
            let quest = Questionnaire(etat: "actif", date: date as NSDate)
            QuestionnaireDTO.add(quest: quest)
            
        case "reponse2":
            let date = Date()
            let quest = Questionnaire(etat: "passif", date: date as NSDate)
            QuestionnaireDTO.add(quest: quest)
        case "reponse3":
            let date = Date()
            let quest = Questionnaire(etat: "actif", date: date as NSDate)
            QuestionnaireDTO.add(quest: quest)
        default:
            break
        }
    }
}
