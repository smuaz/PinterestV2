//
//  PinCollectionViewCell.swift
//  PinterestV2
//
//  Created by Syed Muaz on 06/04/2016.
//  Copyright © 2016 smuaz. All rights reserved.
//

import UIKit

protocol LabelPresentable {
    var text: String { get }
    var textColor: UIColor { get }
}

protocol ImagePresentable {
    var imageName: String { get }
}

typealias PinCollectionViewCellPresentable = protocol<LabelPresentable, ImagePresentable>

class PinCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var pinImageView: UIImageView!
    @IBOutlet private weak var pinLabel: UILabel!
    
    private var delegate: PinCollectionViewCellPresentable?
    
    func configure(withPresenter presenter: PinCollectionViewCellPresentable) {
        delegate = presenter
        
        pinLabel.text = presenter.text
        pinLabel.textColor = presenter.textColor
        
        SMNetwork.manager.downloadImage("\(presenter.imageName)", completionHandler:{(image: UIImage?, url: String) in
            self.pinImageView.image = image
        })

    }
}
