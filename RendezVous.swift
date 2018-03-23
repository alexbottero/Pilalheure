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
    
    init(date: Date, contact: ContactDTO, heureDeb : Date?, heureFin : Date?){
        guard let dao = RendezVousDTO.createDTO() else{
            fatalError("unuable to get dao for medicament")
        }
        guard let daoE = EventDTO.createDTO() else{
            fatalError("unuable to get dao for medicament")
        }
        self.dao = dao
        self.daoE = daoE
        self.dao.events = daoE
        self.dao.contacts = contact
        self.dao.date = date as NSDate
        self.dao.heureDebut = heureDeb as NSDate?
        self.dao.heureFin = heureFin as NSDate?
        let rappel = self.rappels()
        for i in rappel{
            guard let daoR = RappelDTO.createDTO() else{
                fatalError("unuable to get dao for medicament")
            }
            daoR.dateRappel = i as NSDate
            daoR.events = self.daoE
        }
    }
    
    func rappels() -> [Date]{
        let date = [self.date]
        return date
    }
}

