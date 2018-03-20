//
//  Prescription.swift
//  Pilalheure
//
//  Created by Sheena Maucuer on 20/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
class Prescription {
    
    
    internal let dao : PrescriptionDTO
    var medicament   : MedicamentDTO{
        return self.dao.medicaments!
    }
    var dateDebut : Date{
        return self.dao.dateDebut! as Date
    }
    var dateFin  : Date{
        return self.dao.dateFin! as Date
    }
    var heureDebut  : Date?{
        return self.dao.heureDebut! as Date
    }
    var heureFin : Date?{
        return self.dao.heureFin! as Date
    }
    var interval : String?{
        return self.dao.intervalle!
    }
    var heurePrecise : Date?{
        return self.dao.heurePrecise! as Date
    }
    
    init(medicament: MedicamentDTO, dateDebut: Date, dateFin: Date, heureDebut: Date?, heureFin: Date?, intervalle: String?, heurePrecise: Date?){
        guard let dao = PrescriptionDTO.createDTO() else{
            fatalError("unuable to get dao for medicament")
        }
        self.dao = dao
        self.dao.medicaments = medicament
        self.dao.dateDebut = dateDebut as NSDate
        self.dao.dateFin = dateFin as NSDate
        self.dao.heureDebut = heureDebut as! NSDate
        self.dao.heureFin = heureFin as! NSDate
        self.dao.intervalle = intervalle
    }
}

