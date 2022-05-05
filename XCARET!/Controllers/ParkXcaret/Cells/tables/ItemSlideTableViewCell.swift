//
//  ItemSlideTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 1/11/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

protocol ItemSlideTableViewCellDelegete : class {
    func getRestaurants(_sender: ItemSlideTableViewCell)
}

class ItemSlideTableViewCell: UITableViewCell {
    weak var delegate : ItemSlideTableViewCellDelegete?
    @IBOutlet weak var imageslide: UIImageView!
    @IBOutlet weak var lblBtnRestaurantes: UIButton!
    
    var images = [UIImage]()
    var index = 0
    let animationDuration: TimeInterval = 0.25
    let switchingInterval: TimeInterval = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnRestaurants(_ sender: UIButton) {
        delegate?.getRestaurants(_sender: self)
    }
    
    func configInfoView(){
        let name = "lbl_restaurants".getNameLabel().uppercased()//"lblSeeRestaurants".localized().uppercased()
        self.lblBtnRestaurantes.setTitle(name, for: .normal)
        self.images = appDelegate.listImgRestaurantsByPark
        self.animateImageView()
    }
    
    func animateImageView() {
        if self.images.count > 0 {
            UIView.transition(with: self.imageslide, duration: 3.0, options: .transitionCrossDissolve, animations: {
                self.imageslide.image = self.images[self.index]
            }) { (success) in
                if success {
                    self.index += 1
                    if self.index == self.images.count{
                        self.index = 0
                    }
                    self.animateImageView()
                }
                
            }
        }
       
    }
    
}
