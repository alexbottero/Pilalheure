//
//  ExercicePhysique.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 14/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation

class ExercicePhysique {
    private let dao : ExercicePhysiqueDAO
    var nom   : String{
        get{
            return self.dao.nom!
        }
        set{
            self.dao.nom = newValue
        }
    }
    var descript : String{
        get{
            return self.dao.descript!
        }
        set{
            self.dao.descript = newValue
        }
    }
    
    var temps : String?{
        get{
            return self.dao.temps
        }
        set{
            self.dao.temps = newValue!
        }
    }
    var nbRepetition  : String?{
        get{
            return self.dao.nbRepetition
        }
        set{
            self.dao.nbRepetition = newValue!
        }
    }
    init(nom: String, descript: String, temps: String?, nbRepetition: String?){
        guard let dao = ExercicePhysiqueDAO.getNewExercicePhysique() else{
            fatalError("unuable to get dao for ExercicePhysique")
        }
        self.dao = dao
        self.dao.nom = nom
        self.dao.temps = temps
        self.dao.descript = descript
        self.dao.nbRepetition = nbRepetition
    }
}
