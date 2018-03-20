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
    var nom   : String{
        return self.dao.nom!
    }
    var descript : String{
        return self.dao.descript!
    }
    var date : NSDate{
        return self.dao.date!
    }
    

    init(nom: String, descript: String, date: NSDate){
        guard let dao = ExercicePhysiqueDTO.createDTO() else{
            fatalError("unuable to get dao for ExercicePhysique")
        }
        self.dao = dao
        self.dao.nom = nom
        self.dao.descript = descript
        self.dao.date = date
    }
}
