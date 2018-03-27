//
//  DateHelper.swift
//  Pilalheure
//
//  Created by Vincent HERREROS on 21/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
    let calendar = Calendar(identifier: .gregorian)
    
    struct CalendarComponentAmount {
        let component: Calendar.Component
        let amount: Int
    }
    ///Ajoute une nouvelle opération sur le + pour permettre de fonctionner sur des dates. Permet de faire Date + Int
    infix operator +: AdditionPrecedence
    extension Date {
        
        static func +(date: Date, componentAmount: CalendarComponentAmount) -> Date {
            return calendar.date(byAdding: componentAmount.component,
                                 value: componentAmount.amount,
                                 to: date)!
        }
    }


    /// Crée une extension sur le Int pour que celui puisse s'ajouter au dates en lui signifiant de quel type il est (.day pour un jour, .hour pour une heure. (permet de faire Int.day ou Int.hour)
    extension Int {
        
        var years: CalendarComponentAmount {
            return CalendarComponentAmount(component: .year, amount: self)
        }
        
        var months: CalendarComponentAmount {
            return CalendarComponentAmount(component: .month, amount: self)
        }
        
        var days: CalendarComponentAmount {
            return CalendarComponentAmount(component: .day, amount: self)
        }
        
        var hours: CalendarComponentAmount {
            return CalendarComponentAmount(component: .hour, amount: self)
        }
        
        var minutes: CalendarComponentAmount {
            return CalendarComponentAmount(component: .minute, amount: self)
        }
        
        var seconds: CalendarComponentAmount {
            return CalendarComponentAmount(component: .second, amount: self)
        }
    }
