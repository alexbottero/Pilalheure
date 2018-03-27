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
    // list des encouragement possibles
    let encouragements = ["Tu peux le faire !", "N'abandonnes pas ", "Let's go boys", "C'est un petit pas pour toi mais un grand pas pour ta santé", "Croire en soi c'est déjà presque reussir ","C'est les vainqueurs qui écrivent l'histoire"]
    var date   : Date{
        return self.dao.dateRappel! as Date
    }
   
    
    /// initialisateur d'un rappel
    ///
    /// - Parameters:
    ///   - date: date du rappel
    ///   - type: type de rappel : 1 pour activité, 2 pour une prescription, 3 pour un rendez vous et 4 pour un questionnaire
    ///   - event: event auquel le rappel est lié
    init(date : Date, type : Int, event :EventDTO){
        guard let dao = RappelDTO.createDTO() else{
            fatalError("unuable to get dao for Rappel")
        }
        let daoE = event
        self.dao = dao
        self.daoE = daoE
        self.dao.events = daoE
        self.dao.dateRappel = date as NSDate
        // on cree une notifification
        let comps = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let content = UNMutableNotificationContent()
        // un identifiant unique pour chaque notification
        let uuid = UUID().uuidString
        
        
        switch type {
        //creation notification activité
        case 1:
            
            // Generate a random index
            let randomIndex = Int(arc4random_uniform(UInt32(encouragements.count)))
            // Get a random item
            let randomItem = encouragements[randomIndex]
            content.title = "Rappel Activité "
            content.body = "Vous avez une activité à faire : " + (daoE.exercicesPhysiques?.nom)! + "\n " + randomItem
            content.sound = UNNotificationSound.default()
            //requestIdentifier = "RappelAct"
            
        //creation notification prescription
        case 2:
            content.title = "Rappel Prescription "
            content.body = "Vous avez un médicament à prendre :" + (daoE.prescriptions?.medicaments?.nom)! + (daoE.prescriptions?.medicaments?.dose)!
            content.sound = UNNotificationSound.default()
            content.badge = 1
            content.categoryIdentifier = "presCat"
            
        //creation notification rendez vous
        case 3:
            content.body = "Vous avez un rendez-vous dans 1 heure avec " + (daoE.rendezVousS?.contacts?.nom)!
            content.sound = UNNotificationSound.default()
            //requestIdentifier = "rappelRDV"
            
        //creation notification questionnaire
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
        // creation de la requet et ajout au notification center
        let request=UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in
        })
    }
    
}

