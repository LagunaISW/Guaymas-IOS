//
//  MasNoticias.swift
//  GuaymasPro
//
//  Created by Jhonatan Laguna on 24/04/16.
//  Copyright © 2016 Jhonatan Laguna. All rights reserved.
//

import UIKit

private let CellIdentifier = "MoreCell"

class MoreCell: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    
    lazy private var textColour = {
        UIColor(red: 0.196, green: 0.3098, blue: 0.52, alpha: 1.0)
    }()
    
    
    override func awakeFromNib() {
        label.textColor = textColour
        label.text = NSLocalizedString("Load More Button", value: "Load More", comment: "String for Load More button")
    }
    
    
    class var cellIdentifier: String {
        return CellIdentifier
    }
    
}

