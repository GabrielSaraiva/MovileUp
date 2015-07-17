//
//  ShowCell.swift
//  Movile-UP
//
//  Created by iOS on 7/17/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit

class ShowCell: UICollectionViewCell {

    //@IBOutlet private weak var cellNumberLabel: UILabel!
    
    static let colors: [UIColor] = [.greenColor(), .purpleColor(),
        .redColor(), .blueColor(), .orangeColor()]
    
    func loadCellNumber(number: Int) {
        //cellNumberLabel.text = "Cell #\(number)"
        
        let idx = number % ShowCell.colors.count
        backgroundColor = ShowCell.colors[idx]
    }
    
}
