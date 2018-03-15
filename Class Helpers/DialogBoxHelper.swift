//
//  DialogBoxHelper.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 15/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import Foundation
import UIKit

class DialogBoxHelper{
    
    class func alert(view:UIViewController, WithTitle title: String, andMessage msg: String = ""){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(cancelAction)
        view.present(alert,animated: true)
    }
    
    /// Fait apparaître une boite de dialogue lorsqu'il y a une erreur.
    ///
    /// - Parameter error: Erreur donné à la boite de dialogue
     class func alert(view:UIViewController,error: NSError){
        self.alert(view: view, WithTitle:"\(error)", andMessage: "\(error.userInfo)")
    }
}
