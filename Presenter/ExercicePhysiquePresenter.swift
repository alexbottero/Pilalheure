//
//  ExercicePhysiquePresenter.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 15/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation

class ExercicePhysiquePresenter: NSObject{
    fileprivate var nomEx : String = ""
    fileprivate var descEx : String = ""
    
    
    fileprivate var ex : ExercicePhysiqueDTO?=nil{
        didSet{
            if let ex = self.ex{
                if let fnom = ex.nom{
                    self.nomEx = fnom.capitalized
                }
                else{ self.nomEx = "-" }
                if let fdesc = ex.descript{
                    self.descEx = fdesc.capitalized
                }
                else{ self.nomEx = "" }
            }
            else{
                self.descEx = ""
                self.nomEx = ""
            }
        }
    }
    func configure(theCell: ExercicePhysiqueTableViewCell?, forExercicePhysique: ExercicePhysiqueDTO?){
        self.ex = forExercicePhysique
        guard let cell = theCell else {return}
        cell.nomExercicePhysique.text = self.nomEx
        
        
    }
}


