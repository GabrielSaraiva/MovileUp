//
//  ShowsViewController.swift
//  Movile-UP
//
//  Created by iOS on 7/17/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit
import Alamofire
import TraktModels

class ShowsViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet var showCollectionView: UICollectionView!
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) ->UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        /* Celula com a classe ShowCell para mostrar # item na celula
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ShowCell
        
        cell.loadCellNumber(indexPath.item)
        */
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let border = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let itemSize = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
        let maxPerRow = floor((collectionView.bounds.width - border) / itemSize)
        let usedSpace = border + itemSize * maxPerRow
        let space = floor((collectionView.bounds.width - usedSpace) / 2)
        return UIEdgeInsets(top: flowLayout.sectionInset.top, left: space,
    
    bottom: flowLayout.sectionInset.bottom, right: space)
    }
    
    private let httpClient = TraktHTTPClient()
    private var shows: [Show]?
    
    func loadShows(){
        httpClient.getPopularShows { [weak self] result in
            if let shows = result.value {
                println("conseguiu")
                self?.shows = shows
                self?.collectionView?.reloadData()
            } else {
                println("oops \(result.error)")
            }
        }
    }
    
    
    private var task: RetrieveImageTask?
    
    func loadShow(show: Show) {
        let placeholder = UIImage(named: "poster")
        if let url = show.poster?.fullImageURL ?? show.poster?.mediumImageURL ?? show.poster?.thumbImageURL {
        posterImageView.kf_setImageWithURL(url, placeholderImage: placeholder)
    } else {
        posterImageView.image = placeholder
        }
        nameLabel.text = show.title
    }
    
    func teste(){

        httpClient.getShow("game-of-thrones") { [weak self] result in
            println(result.value)
       }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadShows()
        teste()

    }

}




















