//
//  CustomViewController.swift
//  Movile-UP
//
//  Created by iOS on 7/16/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    
    @IBOutlet private weak var episodeImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var overviewLabel: UILabel!
    
    @IBOutlet private weak var overviewTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overviewTextView.textContainer.lineFragmentPadding = 0
        overviewTextView.textContainerInset = UIEdgeInsetsZero
    }
    
}
