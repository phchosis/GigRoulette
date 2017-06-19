//
//  FiltersViewController.swift
//  GigRoulette
//
//  Created by Emal SAIFI on 16/06/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    var currentGeoHash: String = ""
    var eventManager = EventsViewModel()

    @IBOutlet weak var userlocationLabel: UILabel!
    
	@IBOutlet weak var musicBTN: UIButton!
	@IBOutlet weak var sportsBTN: UIButton!
	@IBOutlet weak var comedyBTN: UIButton!
	@IBOutlet weak var artBTN: UIButton!
	@IBOutlet weak var familyBTN: UIButton!
	@IBOutlet weak var theatreBTN: UIButton!
	
	@IBOutlet weak var nowBTN: UIButton!
	@IBOutlet weak var tomorrowBTN: UIButton!
	@IBOutlet weak var anytimeBTN: UIButton!
    
    
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func genreButtonAction(_ sender: Any) {
		let btn:UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
	}
    
	@IBAction func partyAction(_ sender: Any) {
        if eventManager.getEvents().count > 0 {
            let loadingVC = LoadingVC(nibName: "LoadingVC", bundle: nil)
            loadingVC.chosenEvent = eventManager.getEvents().first
            self.show(loadingVC, sender: self)
        }
	}
}
