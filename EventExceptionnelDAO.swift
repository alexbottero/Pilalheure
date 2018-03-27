//
//  EventExceptionnelDAO.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 27/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import Foundation
import CoreData
import UIKit
extension EventExceptionnelDTO{
    static let request : NSFetchRequest<EventExceptionnelDTO> = EventExceptionnelDTO.fetchRequest()
    
    static func createDTO() -> EventExceptionnelDTO?{
        let event = EventExceptionnelDTO(context: CoreDataManager.context)
        return event
    }
}
