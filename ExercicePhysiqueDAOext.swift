//
//  ExercicePhysiqueDAOext.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 14/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ExercicePhysiqueDAO{
    static func getNewExercicePhysique() -> ExercicePhysiqueDAO?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        let moc = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "ExercicePhysiqueDAO", in: moc) else{
            return nil
        }
        let exercicePhysique = ExercicePhysiqueDAO(entity: entity, insertInto: moc)
        return exercicePhysique
    }
    
}
