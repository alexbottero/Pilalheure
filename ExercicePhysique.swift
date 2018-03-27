//
//  ExercicePhysique.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 14/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation

class ExercicePhysique {
    internal let dao : ExercicePhysiqueDTO
    internal let daoE : EventDTO
    
    var nom   : String{
        return self.dao.nom!
    }
    var descript : String{
        return self.dao.descript!
    }
    var date : NSDate{
        return self.dao.date!
    }
    

    /// initialisateur exercice physique
    ///
    /// - Parameters:
    ///   - nom: nom exercice
    ///   - descript: description de l'exercice
    ///   - date: date de l'exercice
    init(nom: String, descript: String, date: NSDate){
        guard let dao = ExercicePhysiqueDTO.createDTO() else{
            fatalError("unuable to get dao for ExercicePhysique")
        }
        guard let daoE = EventDTO.createDTO() else{
            fatalError("unuable to get dao for Event")
        }
        self.dao = dao
        self.dao.nom = nom
        self.dao.descript = descript
        self.dao.date = date
        self.daoE = daoE
        self.dao.events = daoE
        self.daoE.exercicesPhysiques = dao
        let _ = Rappel(date: date as Date, type: 1, event: daoE)

            
    }
}
