//
//  Prescription.swift
//  Pilalheure
//
//  Created by Sheena Maucuer on 20/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
class Prescription {
    
    
    internal let daoPrescription : PrescriptionDTO
    internal let daoEvent : EventDTO
    var medicament   : MedicamentDTO{
        return self.daoPrescription.medicaments!
    }
    var dateDebut : Date{
        return self.daoPrescription.dateDebut! as Date
    }
    var dateFin  : Date{
        return self.daoPrescription.dateFin! as Date
    }
    var heureDebut  : Date?{
        return self.daoPrescription.heureDebut! as Date
    }
    var heureFin : Date?{
        return self.daoPrescription.heureFin! as Date
    }
    var interval : Int64?{
        return self.daoPrescription.intervalle
    }
    var heurePrecise : Date?{
        return self.daoPrescription.heurePrecise! as Date
    }
    
    /// Création d'un PrescriptionDTO, suivant différent paramètre possible (1 date, 2 date, prise supplémentaire si intervalle
    ///
    /// - Parameters:
    ///   - medicament: MedicamentDTO, médicament de la prescription
    ///   - dateDebut: Date, date de début de prise
    ///   - dateFin: Date, date de fin de prise
    ///   - heureDebut: Date, heure de début de prise. Si seule heure, alors deviens heure précise
    ///   - heureFin: Date, heure de fin de prise. Si aucun intervalle, heure début et heure fin seront les seules prises de la journée
    ///   - intervalle: Int, nombre de prise que l'on veut rajouter dans la journée entre les deux heures de début et fin
    ///   - heurePrecise: Date
    init(medicament: MedicamentDTO, dateDebut: Date, dateFin: Date, heureDebut: Date?, heureFin: Date?, intervalle: Int64?, heurePrecise: Date?){
        guard let daoP = PrescriptionDTO.createDTO() else{
            fatalError("unuable to get dao for prescription")
        }
        guard let daoE = EventDTO.createDTO() else{
            fatalError("unuable to get dao for event")
        }
        // Affection des variables et des DTO pour créer les liens dans le CoreData
        self.daoPrescription = daoP
        self.daoPrescription.medicaments = medicament
        self.daoEvent = daoE
        self.daoPrescription.events = daoEvent
        self.daoPrescription.dateDebut = dateDebut as NSDate
        self.daoPrescription.dateFin = dateFin as NSDate
        self.daoPrescription.heureDebut = heureDebut as NSDate?
        self.daoPrescription.heureFin = heureFin as NSDate?
        if let interval = intervalle{
            self.daoPrescription.intervalle = interval
        }
        self.daoPrescription.heurePrecise = heurePrecise as NSDate?
        //Tableau contenant toutes les prises que devrai faire le patient pour la prescription
        var rappels = [Date]()
        if let hdeb = heureDebut{
            if let hfin = heureFin{
                // Effectué si on a une heure début et une heure fin, possiblement un intervalle(non obligatoire)
                rappels = createRappels(heureDebut: hdeb, heureFin: hfin, intervalle: intervalle)
            }
            else{
                // Effectué si seule un heure début est présente
                rappels = createRappels(heurePrecise: heureDebut!)
            }
        }
        var i = rappels.count
        //Création des rappels dans la base
        while (i>0){
            Rappel(date: rappels[i-1], type: 2, event: daoE)
            i=i-1
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy 'at' HH:mm"
        for d in rappels {
            let stringDate = dateFormatter.string(from: d as Date)
            print(stringDate)
        }
    }
    
    
    
    /// Fonction de création de rappels dans le cas ou l'heure de début et l'heure de fin sont présentes
    ///
    /// - Parameters:
    ///   - hdeb: Date, heure de début de la prise dans la journéee
    ///   - hfin: date, heure de fin de la prise dans la journée
    ///   - inter: Int, nombre de prise que l'on veut rajouter dans la journée (optionnel)
    /// - Returns: retourne un tableau de Date correspondant à toutes les prises
    func createRappels(heureDebut hdeb : Date, heureFin hfin : Date, intervalle inter : Int64?) -> [Date]{
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
        var componentsDate = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateDebut)
        var componentsDateFin = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateFin)
        componentsDate.hour = 0
        componentsDate.minute = 0
        componentsDateFin.hour = 0
        componentsDateFin.minute = 0
        //change the time
        var date = gregorian.date(from: componentsDD)!
        var dEnd = gregorian.date(from: componentsDateFin)
        dEnd = dEnd! + 1.days
        var x = false
        var ecart : Int = 0
        // création de l'intervalle de temps entre chaque prise
        if let inter2 = inter{
            x = true
            ecart=Int(dif/(inter2+1))
        }
        // Si le jour actuel du rappel est inférieur au jour de fin, on continue de créer les rappels
        while date <= dEnd! {
            var componentsD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            componentsD.hour = componentsHD.hour
            componentsD.minute = componentsHD.minute
            date = gregorian.date(from: componentsD)!
            rappels.append(date)
            if(x){
                for _ in 0...inter!{
                    date = date + ecart.seconds
                    rappels.append(date)
                }
            }
            else{
                date = date + Int(dif).seconds
                rappels.append(date)
            }
            date = date + 1.days
        }

        return rappels
    }
    
    /// Creéation des rappels dans le cas ou seul l'heure de début est présente, cela devient une heure précise
    ///
    /// - Parameter hP: date, heure de la prise dans la journée
    /// - Returns: Retourne un tableau de Date correspondant au rappels des prises
    func createRappels(heurePrecise hP : Date) -> [Date]{
        //création du tableau de rappels
        var rappels = [Date]()
        let gregorian = Calendar(identifier: .gregorian)
        //création des composants pour effectuer les changement de dates -> Jour date Debut + heure de heure Debut
        var componentsDD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateDebut)
        let componentsHP = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: hP)
        componentsDD.hour = componentsHP.hour
        componentsDD.minute = componentsHP.minute
        //change the time
        var componentsDate = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateDebut)
        var componentsDateFin = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateFin)
        componentsDate.hour = 0
        componentsDate.minute = 0
        componentsDateFin.hour = 0
        componentsDateFin.minute = 0
        //change the time
        var date = gregorian.date(from: componentsDD)!
        var dEnd = gregorian.date(from: componentsDateFin)
        dEnd = dEnd! + 1.days
        // Si le jour actuel du rappel est inférieur au jour de fin, on continue de créer les rappels
        while date <= dEnd! {
            rappels.append(date)
            date = date + 1.days
        }
       
        return rappels
    }
}

