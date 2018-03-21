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
            let timeInterval = hfin.timeIntervalSince(hdeb)
            // convert to Integer
            var dif = Int64(timeInterval)
            if(inter > 0){
                dif=dif/inter+1
            }
            var rappels = [Date]()
            
            let gregorian = Calendar(identifier: .gregorian)
            var componentsDD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateDebut)
            var componentsHD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: heureDebut!)
            
            // Change the time to 9:30:00 in your locale
            componentsDD.hour = componentsHD.hour
            componentsDD.minute = componentsHD.minute
            
            let date = gregorian.date(from: componentsDD)!
            
            rappels.append(date)
            let heure = hdeb + 5.minutes
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let stringDate = dateFormatter.string(from: heure as Date)
            print(stringDate)
            dateFormatter.dateFormat = "dd-MM-yyyy 'at' HH:mm"
            print(date)

 
            //let timeInterval = Double(myInt)
            
            // create NSDate from Double (NSTimeInterval)
            //let myNSDate = Date(timeIntervalSince1970: timeInterval)
        }
    }
}

