//
//  DynamicCollectionView.swift
//  XCARET!
//
//  Created by Angelica Can on 1/30/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class DynamicCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            print("bound size \(bounds.size)")
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
}
