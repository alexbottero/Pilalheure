//
//  QuestionnaireDAO.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 21/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension QuestionnaireDTO{
    static let request : NSFetchRequest<QuestionnaireDTO> = QuestionnaireDTO.fetchRequest()

    static func createDTO() -> QuestionnaireDTO?{
        let quest = QuestionnaireDTO(context: CoreDataManager.context)
        return quest
    }

    static func add(quest: Questionnaire){
        if self.count(quest: quest) > 1{
            CoreDataManager.context.delete(quest.dao)
        }
        else{
            CoreDataManager.save()
        }
    }

    static func count(quest: Questionnaire) -> Int{
        let predicate = NSPredicate(format:"etat == %@ AND date == %@ ",quest.etat,quest.date)
        self.request.predicate = predicate
        do{
            return try CoreDataManager.context.count(for: self.request)
        }
        catch{
            fatalError()
        }
    }
    
    /// Fonction de récupératioon des questionnaire en fonction du rendez-vous et du jour que l'on désire. Inutilisable
    ///
    /// - Parameters:
    ///   - Rdv: RendezVousDTO
    ///   - jour: Int
    /// - Returns: Return un tableau de NSObject, contenant des Questionnaires
    static func selectPerDay(Rdv: RendezVousDTO, jour: Int) -> [NSObject]{
        let d = Calendar.current.date(byAdding: .day, value: -jour, to: Rdv.date! as Date)
        let gregorian = Calendar(identifier: .gregorian)
        //création des composants pour effectuer les changement de dates -> Jour date Debut + heure de heure Debut
        var componentsDD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: d!)
        //change the time
        componentsDD.hour = 0
        componentsDD.minute = 0
        let dateD = gregorian.date(from: componentsDD)!
        let v = Calendar.current.date(byAdding: .day, value: -jour+1, to: Rdv.date! as Date)
        componentsDD = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: v!)
        let dateF = gregorian.date(from: componentsDD)!
        let predicate = NSPredicate(format:"date < %@ AND date > %@", dateD as CVarArg, dateF as CVarArg)
        self.request.predicate = predicate
        do{
            return try CoreDataManager.context.fetch(self.request)
        }
        catch{
            fatalError()
        }
        
    }
}
