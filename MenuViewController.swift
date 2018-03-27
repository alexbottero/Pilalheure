//
//  LaunchViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 13/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit
import CoreData
class MenuViewController: UIViewController{
    //MARK:-Variables
    @IBOutlet weak var nomEvent: UILabel!
    @IBOutlet weak var dateEvent: UILabel!
    var data : [RappelDTO]? = [RappelDTO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      Background.color(controleur: self)
        loadIntro()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        loadIntro()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- gestion dernier event-
    
    /// Permet de charger le dernier event pour l'afficher sur l'ecran d'accueil
    func loadIntro(){
        let context = CoreDataManager.context
        let dateJ = Date()
        let request : NSFetchRequest<RappelDTO> = RappelDTO.fetchRequest()
        let predicate = NSPredicate(format:"dateRappel > %@", dateJ as CVarArg)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(RappelDTO.dateRappel), ascending:true)]
        do{
            try self.data = context.fetch(request)
        }catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
        var i = 0
        if(data?.count != 0){
            while(data?[i].dateRappel as Date! < dateJ){
                i = i+1
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let stringDate = dateFormatter.string(from: data?[i].dateRappel as! Date)
            if let medoc = data?[i].events?.prescriptions?.medicaments?.nom{
                self.nomEvent.text = medoc
                self.dateEvent.text = stringDate
            }
            else if let activite = data?[i].events?.exercicesPhysiques?.nom{
                self.nomEvent.text = activite
                self.dateEvent.text = stringDate
            }
            else if let rdv = data?[i].events?.rendezVousS?.contacts?.nom{
                self.nomEvent.text = rdv
                self.dateEvent.text = stringDate
            }
            else{
                self.nomEvent.text = "Pas de prochain événement"
                self.dateEvent.text = ""
            }
        }else{
            self.nomEvent.text = "Pas de prochain événement"
            self.dateEvent.text = ""
        }
        
    }

}

