//
//  Questionnaire.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 21/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation

class Questionnaire {
    

    internal let dao : QuestionnaireDTO
    var etat   : String{
        return self.dao.etat!
    }
    var date : NSDate{
        return self.dao.date!
    }
    
    init(etat: String, date: NSDate){
        guard let dao = QuestionnaireDTO.createDTO() else{
            fatalError("unuable to get dao for medicament")
        }
        self.dao = dao
        self.dao.etat = etat
        self.dao.date = date
    }
    
}
