//
//  RendezVousDAO.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 22/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension RendezVousDTO{
    static let request : NSFetchRequest<RendezVousDTO> = RendezVousDTO.fetchRequest()
    
    static func createDTO() -> RendezVousDTO?{
        let rendezVous = RendezVousDTO(context: CoreDataManager.context)
        return rendezVous
    }
    
    static func add(rendezVous: RendezVous){
        CoreDataManager.save()
        /*if self.count(prescription: prescription) > 1{
         CoreDataManager.context.delete(prescription.dao)
         }
         else{
         CoreDataManager.save()
         }*/
    }
    
    
    static func delete(rendezVous : RendezVousDTO){
        CoreDataManager.context.delete(rendezVous)
        CoreDataManager.save()
    }
    
}
