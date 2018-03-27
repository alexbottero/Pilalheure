//
//  EventExceptionnel.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 27/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
class EventExceptionnel {
    internal let dao : EventExceptionnelDTO
    var nom   : String{
        return self.dao.nom!
    }
    var date : Date{
        return self.dao.date! as Date
    }
    
    
    /// initialisateur d'un event exceptionnel
    ///
    /// - Parameters:
    ///   - nom: nom de l'event
    ///   - date: date
    ///   - rendezVous: rendez vous associé
    init(nom: String, date: Date, rendezVous: RendezVousDTO){
        guard let dao = EventExceptionnelDTO.createDTO() else{
            fatalError("unuable to get dao for ExercicePhysique")
        }
        self.dao = dao
        self.dao.nom = nom
        self.dao.date = date as NSDate
        self.dao.rendezVousEventEx = rendezVous
        rendezVous.eventsExceptionnels = dao
    }
}
