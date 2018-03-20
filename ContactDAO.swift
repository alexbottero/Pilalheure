//
//  ContactDAO.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 20/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ContactDTO{
    static let request : NSFetchRequest<ContactDTO> = ContactDTO.fetchRequest()
    
    static func createDTO() -> ContactDTO?{
        let cont = ContactDTO(context: CoreDataManager.context)
        return cont
    }
    
    static func add(cont: Contact){
        if self.count(cont: cont) > 1{
            CoreDataManager.context.delete(cont.dao)
        }
        else{
            CoreDataManager.save()
        }
    }
    
    static func count(cont: Contact) -> Int{
        let predicate = NSPredicate(format:"nom == %@ ",cont.nom)
        self.request.predicate = predicate
        do{
            return try CoreDataManager.context.count(for: self.request)
        }
        catch{
            fatalError()
        }
    }
    
    static func delete(cont : ContactDTO){
        CoreDataManager.context.delete(cont)
        CoreDataManager.save()
    }
}
