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

    @IBOutlet weak var nomEvent: UILabel!
    @IBOutlet weak var dateEvent: UILabel!
    
    var data : [RappelDTO]? = [RappelDTO]()
    
    func loadIntro(){
        let context = CoreDataManager.context
        var dateJ = Date()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
      Background.color(controleur: self)
        loadIntro()
        print(Date())
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadIntro()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

