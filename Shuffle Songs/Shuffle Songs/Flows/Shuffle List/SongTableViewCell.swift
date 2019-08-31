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
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = nil
        
        self.textLabel?.textColor = DesignConfigurator.fontMainColor
        self.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        self.detailTextLabel?.textColor = DesignConfigurator.fontSecondaryColor
    }
    
    private func configure(title: String, subtitle: String, imageURL: String) {
        self.textLabel?.text = title
        self.detailTextLabel?.text = subtitle
    }
    
    
}
