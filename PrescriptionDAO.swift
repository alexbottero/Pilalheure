//
//  PrescriptionDAO.swift
//  Pilalheure
//
//  Created by Sheena Maucuer on 20/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension PrescriptionDTO{
    static let request : NSFetchRequest<PrescriptionDTO> = PrescriptionDTO.fetchRequest()
    
    static func createDTO() -> PrescriptionDTO?{
        let prescription = PrescriptionDTO(context: CoreDataManager.context)
        return prescription
    }
    
    static func add(prescription: Prescription){
        if self.count(prescription: prescription) > 10000{
            CoreDataManager.context.delete(prescription.daoPrescription)
        }
        else{
            CoreDataManager.save()
        }
    }
    
    static func count(prescription: Prescription) -> Int{
        let predicate = NSPredicate(format:"medicaments.nom == %@", prescription.medicament.nom!)
        self.request.predicate = predicate
        do{
            return try CoreDataManager.context.count(for: self.request)
        }
        catch{
            fatalError()
        }
    }

    
    static func delete(prescription : PrescriptionDTO){
        CoreDataManager.context.delete(prescription)
        CoreDataManager.save()
    }
    
}
