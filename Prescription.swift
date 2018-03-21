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
    var interval : Int64?{
        return self.dao.intervalle
    }
    var heurePrecise : Date?{
        return self.dao.heurePrecise! as Date
    }
    
    init(medicament: MedicamentDTO, dateDebut: Date, dateFin: Date, heureDebut: Date?, heureFin: Date?, intervalle: Int64?, heurePrecise: Date?){
        guard let dao = PrescriptionDTO.createDTO() else{
            fatalError("unuable to get dao for medicament")
        }
        self.dao = dao
        self.dao.medicaments = medicament
        self.dao.dateDebut = dateDebut as NSDate
        self.dao.dateFin = dateFin as NSDate
        self.dao.heureDebut = heureDebut as NSDate?
        self.dao.heureFin = heureFin as NSDate?
        if let interval = intervalle{
            self.dao.intervalle = interval
        }
        self.dao.heurePrecise = heurePrecise as NSDate?
        if let hdeb = heureDebut, let hfin = heureFin, let inter = intervalle{
            // convert Date to TimeInterval (typealias for Double)
            let rappels : [Date] = createRappels(heureDebut: hdeb, heureFin: hfin, intervalle: inter)
        }
    }
    
    func createRappels(heureDebut hdeb : Date, heureFin hfin : Date, intervalle inter : Int64) -> [Date]{
        //intervalle de temps entre 2 dates
        let timeInterval = hfin.timeIntervalSince(hdeb)
        // conversion en Int
        let dif = Int64(timeInterval)
        //Si intervalle > 0 -> in faut ajouter autant de rappel que necessaire
        
        //création du tableau de rappels
        var rappels = [Date]()
        let gregorian = Calendar(identifier: .gregorian)
        //création des composants pour effectuer les changement de dates -> Jour date Debut + heure de heure Debut
        let componentsDD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateDebut)
        var componentsHD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: hdeb)
        
        //change the time
        var date = gregorian.date(from: componentsDD)!
        let ecart=Int(dif/(inter+1))
        print(dif)
        print(ecart)
        while date < dateFin {
            var componentsD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            componentsD.hour = componentsHD.hour
            componentsD.minute = componentsHD.minute
            date = gregorian.date(from: componentsD)!
            rappels.append(date)
            for _ in 0...inter{
                date = date + ecart.seconds
                rappels.append(date)
            }
            date = date + 1.days
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy 'at' HH:mm"
        for d in rappels {
            let stringDate = dateFormatter.string(from: d as Date)
            print(stringDate)
        }
        
        
        //let timeInterval = Double(myInt)
        
        // create NSDate from Double (NSTimeInterval)
        //let myNSDate = Date(timeIntervalSince1970: timeInterval)
        return rappels
    }
}

