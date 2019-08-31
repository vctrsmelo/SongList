//
//  SongTableViewCell.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 31/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
