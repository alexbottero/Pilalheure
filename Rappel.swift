//
//  Rappel.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 25/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UserNotifications

class Rappel {
    
    internal let dao : RappelDTO
    internal let daoE: EventDTO
    var date   : Date{
        return self.dao.dateRappel! as Date
    }
   
    
    init(date : Date, type : Int, event :EventDTO){
        guard let dao = RappelDTO.createDTO() else{
            fatalError("unuable to get dao for Rappel")
        }
        let daoE = event
        self.dao = dao
        self.daoE = daoE
        self.dao.events = daoE
        self.dao.dateRappel = date as NSDate
        
        let comps = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
        print(comps)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let content = UNMutableNotificationContent()
        let uuid = UUID().uuidString
        switch type {
        case 1:
            content.title = "Rappel Activité "
            content.body = "Vous avez une activité à faire : " + (daoE.exercicesPhysiques?.nom)!
            content.sound = UNNotificationSound.default()
            //requestIdentifier = "RappelAct"
            
        case 2:
            content.title = "Rappel Prescription "
            content.body = "Vous avez un médicament à prendre :" + (daoE.prescriptions?.medicaments?.nom)! + (daoE.prescriptions?.medicaments?.dose)!
            content.sound = UNNotificationSound.default()
            content.badge = 1
            content.categoryIdentifier = "presCat"

        case 3:
            content.body = "Vous avez un rendez-vous dans 1 heure avec " + (daoE.rendezVousS?.contacts?.nom)!
            content.sound = UNNotificationSound.default()
            //requestIdentifier = "rappelRDV"
            
            
        case 4:
            content.title = " Questionnaire d'etat"
            content.subtitle = " rendez vous chez le neurologue proche"
            content.body = " Quel est votre état ?"
            content.badge = 1
            content.categoryIdentifier = "questCat"
            //requestIdentifier = "EtatQuestionnaire"
            
            
        default:
            break
        }
        
        let request=UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in
        })
    }
    
}

