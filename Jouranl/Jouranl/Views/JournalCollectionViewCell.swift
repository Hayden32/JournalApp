//
//  JournalCollectionViewCell.swift
//  Jouranl
//
//  Created by Hayden Hastings on 7/30/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit

class JournalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageCoverView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeAndRoomLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    
    static let reuseIdentifiter = String(describing: JournalCollectionViewCell.self)
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        // 1
        let standardHeight = JournalLayoutConstants.Cell.standardHeight
        let featuredHeight = JournalLayoutConstants.Cell.featuredHeight
        
        // 2
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        
        // 3
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        timeAndRoomLabel.alpha = delta
        speakerLabel.alpha = delta
    }
}
