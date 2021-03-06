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
    var filterViewModel = FiltersViewModel()

    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    @IBOutlet weak var musicBTN: UIButton!
    @IBOutlet weak var sportsBTN: UIButton!
    @IBOutlet weak var comedyBTN: UIButton!
    @IBOutlet weak var artBTN: UIButton!
    @IBOutlet weak var familyBTN: UIButton!
    @IBOutlet weak var theatreBTN: UIButton!
	
    @IBOutlet weak var nowBTN: UIButton!
    @IBOutlet weak var tomorrowBTN: UIButton!
    @IBOutlet weak var anytimeBTN: UIButton!
    
    @IBOutlet weak var filterActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        filterViewModel.getEvents(withCompletionHandler: { (events) in
            DispatchQueue.main.async {
                self.filterCollectionView.reloadData()
                self.filterActivityIndicatorView.stopAnimating()
            }
        }, andFailureHandler: nil)
    }
    
    private func setupCollectionView() {
        filterCollectionView?.allowsMultipleSelection = true
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        filterCollectionView.collectionViewLayout = collectionFlowLayout
    }
	
    @IBAction func genreButtonAction(_ sender: Any) {
        let btn:UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
    }
    
    @IBAction func partyAction(_ sender: Any) {
        if filterViewModel.getEvents().count > 0 {
            let loadingVC = LoadingVC(nibName: "LoadingVC", bundle: nil)
            loadingVC.chosenEvent = filterViewModel.getFilteredEvent()
            navigationController?.pushViewController(loadingVC, animated: true)
        }
    }
}

extension FiltersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterViewModel.getGenres().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.genre = filterViewModel.getGenres()[indexPath.row]
        
        if !filterViewModel.selectedGenres.isEmpty {
            if filterViewModel.selectedGenres.contains(cell.genre!) {
                cell.isSelected = true
                return cell
            }
        }
        
        return cell
    }
}

extension FiltersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        filterViewModel.select(genre: (collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell).genre!)
        print(filterViewModel.selectedGenres.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(indexPath)
        filterViewModel.deSelect(genre: (collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell).genre!)
        print(filterViewModel.selectedGenres.count)
    }
}

extension FiltersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genreTitle = filterViewModel.getGenres()[indexPath.row].name
        return CGSize(width: genreTitle.widthOfString(usingFont: FilterCollectionViewCell().font) + 8.0,
                      height: genreTitle.heightOfString(usingFont: FilterCollectionViewCell().font) + 20.0)
    }
}
