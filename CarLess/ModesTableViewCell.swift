//
//  TransportationModeTableViewCell.swift
//  CarLess
//
//  Created by Whyceewhite on 7/1/15.
//  Copyright (c) 2015 Galloway Mobile. All rights reserved.
//

import UIKit

class ModesTableViewCell: UITableViewCell {

    @IBOutlet weak var modeImage: UIImageView!
    
    @IBOutlet weak var modeName: UILabel!
    
    @IBAction func selectMode(sender: UIButton) {
    }
    
    var modeType: ModeType? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        modeImage?.image = nil
        modeName?.text = nil
        
        if let modeType = self.modeType {
            modeName?.text = modeType.name
            modeImage?.image = UIImage(named: modeType.imageFilename)
        }
    }
    
}
