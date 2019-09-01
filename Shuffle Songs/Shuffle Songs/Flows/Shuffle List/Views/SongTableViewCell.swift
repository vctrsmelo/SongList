//
//  SongTableViewCell.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 31/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    // MARK: Subviews
    
    private let verticalStack: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alignment = .fill
        v.axis = .vertical
        v.distribution = .fill
        v.spacing = 2
        return v
    }()
    
    private let horizontalStack: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alignment = .center
        v.axis = .horizontal
        v.distribution = .fill
        v.spacing = 4
        return v
    }()
    
    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()

    private let artistNameLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()
    
    // MARK: Content
    
    var artworkImage: UIImage? {
        return artworkImageView.image
    }

    var artistName: String? {
        return artistNameLabel.text
    }
    
    var songName: String? {
        return songNameLabel.text
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = nil
        
        setupHorizontalStack()
        setupArtworkImageView()
        setupSongNameLabel()
        setupArtistNameLabel()
        
        horizontalStack.addArrangedSubview(verticalStack)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = DesignConfigurator.navigationBarColor
        self.selectedBackgroundView = backgroundView
    }
    
    private func setupHorizontalStack() {
        self.contentView.addSubview(horizontalStack)
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        let topMargin = horizontalStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
        topMargin.priority = .defaultHigh
        topMargin.isActive = true
        
        let bottomMargin = horizontalStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        bottomMargin.priority = .defaultHigh
        bottomMargin.isActive = true
        
        let leftMargin = horizontalStack.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor)
        leftMargin.priority = .defaultHigh
        leftMargin.isActive = true
        
        let rightMargin = horizontalStack.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor)
        rightMargin.priority = .defaultHigh
        rightMargin.isActive = true
    }
    
    private func setupArtworkImageView() {
        horizontalStack.addArrangedSubview(artworkImageView)
        
        artworkImageView.translatesAutoresizingMaskIntoConstraints = false
        artworkImageView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        artworkImageView.widthAnchor.constraint(equalTo: artworkImageView.heightAnchor).isActive = true
        artworkImageView.centerYAnchor.constraint(equalTo: horizontalStack.centerYAnchor).isActive = true
        artworkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
        artworkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25).isActive = true
        
        artworkImageView.layer.masksToBounds = false
        artworkImageView.layer.cornerRadius = 8
        artworkImageView.clipsToBounds = true
    }
    
    private func setupSongNameLabel() {
        verticalStack.addArrangedSubview(songNameLabel)
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        songNameLabel.leftAnchor.constraint(equalTo: verticalStack.leftAnchor, constant: 30).isActive = true
        songNameLabel.textColor = DesignConfigurator.fontMainColor
        songNameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        songNameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupArtistNameLabel() {
        verticalStack.addArrangedSubview(artistNameLabel)
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        songNameLabel.leftAnchor.constraint(equalTo: songNameLabel.leftAnchor).isActive = true
        artistNameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        artistNameLabel.textColor = DesignConfigurator.fontSecondaryColor
        artistNameLabel.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - Configure
    
    func configure(songName: String, artistName: String, artworkImage: UIImage?) {
        self.songNameLabel.text = songName
        self.artistNameLabel.text = artistName
        self.artworkImageView.image = artworkImage
    }
    
    
}
