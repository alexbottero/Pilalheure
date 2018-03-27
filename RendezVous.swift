//
//  RendezVous.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 22/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
class RendezVous {
    
    
    internal let dao : RendezVousDTO
    internal let daoE : EventDTO
    
    var date : Date{
        return self.dao.date! as Date
    }
    var contact : ContactDTO{
        return self.dao.contacts!
    }
    var heureDebut : Date{
        return self.dao.heureDebut! as Date
    }
    
    var heureFin : Date{
        return self.dao.heureFin! as Date
    }
    
    
    /// initialisateur de rendez vous
    ///
    /// - Parameters:
    ///   - date: date rendez vous
    ///   - contact: contact
    ///   - heureDeb: heure debut du rendez vous
    ///   - heureFin: heure fin du rendez vous
    init(date: Date, contact: ContactDTO, heureDeb : Date?, heureFin : Date?){
        guard let dao = RendezVousDTO.createDTO() else{
            fatalError("unuable to get dao for medicament")
        }
        guard let daoE = EventDTO.createDTO() else{
            fatalError("unuable to get dao for medicament")
        }
        // on fait les relations
        self.dao = dao
        self.daoE = daoE
        self.dao.events = daoE
        self.dao.contacts = contact
        self.dao.date = date as NSDate
        self.dao.heureDebut = heureDeb as NSDate?
        self.dao.heureFin = heureFin as NSDate?
        var rappelsQuestionnaire = [Date]()
        let rappelRdv: Date = createRappels(heureRappel: date)
        // on regarde si c'est un neurologue
        if (contact.profession == "neurologue"){
            //si oui on programme les rappels de questionnaire
            rappelsQuestionnaire = createRappels(heureDebut: heureDeb!, heureFin: heureFin!, dateFin: date)
        }
        // creation rappel rendez vous
        self.daoE.rendezVousS = dao
        let _ = Rappel(date: rappelRdv as Date, type: 3, event: daoE)
        
        for i in rappelsQuestionnaire{
            // creation rappel questionnaire
            let _ = Rappel(date: i as Date, type: 4, event: daoE)
            
        }
    }
    
    
    
    /// creation rappel une heure avant le rendez vous
    ///
    /// - Parameter hR: heure du rendez vous
    /// - Returns: heure du rappel
    func createRappels(heureRappel hR : Date) -> Date{
        
        let heureRappel = Calendar.current.date(byAdding: .hour, value: -1, to: hR)
        var rappel : Date
        rappel = heureRappel!
        return rappel
    }
    
    
   /// creation des heures  des questionnaires pour le patient des 5 jours avant le rdv chez le neurologue
   ///
   /// - Parameters:
   ///   - hdeb: heure debut questionnaire
   ///   - hfin: heure fin des questionnaire
   ///   - fin: date du rendez vous (fin des rappel)
   /// - Returns: tableau de date des questionnaire
   func createRappels(heureDebut hdeb : Date, heureFin hfin : Date, dateFin fin : Date) -> [Date]{
        //intervalle de temps entre 2 dates
    
        let debut = Calendar.current.date(byAdding: .day, value: -5, to: fin)
        let timeInterval = hfin.timeIntervalSince(hdeb)
        // conversion en Int
        let dif = Int64(timeInterval)
        let heures : Int64 = dif/3600
        //Si intervalle > 0 -> in faut ajouter autant de rappel que necessaire
        
        //création du tableau de rappels
        var rappels = [Date]()
        var gregorian = Calendar.current
        gregorian.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        //création des composants pour effectuer les changement de dates -> Jour date Debut + heure de heure Debut
        let componentsDD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: debut!)
        var componentsHD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: hdeb)
        
        //change the time
        var date = gregorian.date(from: componentsDD)!
        var dDay = calendar.component(.day, from: date)
    
        let dEnd = calendar.component(.day, from: fin)
        while dDay <= dEnd {
            var componentsD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            componentsD.hour = componentsHD.hour
            componentsD.minute = componentsHD.minute
            date = gregorian.date(from: componentsD)!
            rappels.append(date)
            for _ in 0...heures{
                print(date)
                date = date + 1.hours
                rappels.append(date)}
            date = date + 1.days
            dDay = calendar.component(.day, from: date)
        }
        return rappels
    }
}

