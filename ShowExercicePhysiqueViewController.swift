//
//  ShowExercicePhysiqueViewController.swift
//  Pilalheure
//
//  Created by Bottero Alexandre  on 14/03/2018.
//  Copyright © 2018 Vincent HERREROS. All rights reserved.
//

import UIKit

class ShowExercicePhysiqueViewController: UIViewController {

    @IBOutlet weak var nbRepEx: UILabel!
    @IBOutlet weak var tempsEx: UILabel!
    @IBOutlet weak var nomEx: UILabel!
    @IBOutlet weak var descEx: UITextView!
    var exPhys: ExercicePhysiqueDAO? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let aExPhys = self.exPhys{
            self.nomEx.text = aExPhys.nom
            self.descEx.text = aExPhys.descript
            self.tempsEx.text = aExPhys.temps
            self.nbRepEx.text = aExPhys.nbRepetition
        }
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
