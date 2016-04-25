//
//  PinViewModel.swift
//  PinterestV2
//
//  Created by Syed Muaz on 24/04/2016.
//  Copyright © 2016 smuaz. All rights reserved.
//

import UIKit

struct PinViewModel: PinCollectionViewCellPresentable {
    
    let text: String
    let imageName: String

    init(_ pin: Pin) {
        text = pin.caption
        imageName = pin.imageStr
    }
}

extension PinViewModel {
    var textColor: UIColor { return .darkGrayColor() }
}
