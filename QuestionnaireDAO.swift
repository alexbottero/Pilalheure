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
}
