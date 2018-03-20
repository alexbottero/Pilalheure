//
//  ExercicePhysiqueDTOext.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 14/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ExercicePhysiqueDTO{
    static let request : NSFetchRequest<ExercicePhysiqueDTO> = ExercicePhysiqueDTO.fetchRequest()
    
    static func createDTO() -> ExercicePhysiqueDTO?{
        let exPhys = ExercicePhysiqueDTO(context: CoreDataManager.context)
        return exPhys
    }
    
    static func add(exPhys: ExercicePhysique){
        if self.count(exPhys: exPhys) > 1{
            CoreDataManager.context.delete(exPhys.dao)
        }
        else{
            CoreDataManager.save()
        }
    }
    
    static func count(exPhys: ExercicePhysique) -> Int{
        let predicate = NSPredicate(format:"nom == %@ ",exPhys.nom)
        self.request.predicate = predicate
        do{
            return try CoreDataManager.context.count(for: self.request)
        }
        catch{
            fatalError()
        }
    }
    
    static func delete(exPhys : ExercicePhysiqueDTO){
        CoreDataManager.context.delete(exPhys)
        CoreDataManager.save()
    }
    
}
