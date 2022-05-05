//
//  ItemRoomTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 7/1/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemRoomTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imageSlide: UIImageView!
    @IBOutlet weak var lblRoom: UILabel!
    
    var images = [UIImage]()
    let animationDuration: TimeInterval = 0.5
    let switchingInterval: TimeInterval = 8
    var index = 0
    var itemDet : [ItemDetailImages] = [ItemDetailImages]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configTableCell(itemInfo: ItemInfoHotel){
        self.lblTitle.text = itemInfo.title
        self.lblDescription.text = itemInfo.subtitle
        self.itemDet = itemInfo.listDetailImages
        animateImageView()
    }

    func animateImageView() {
        UIView.transition(with: self.imageSlide, duration: 3.0, options: .transitionCrossDissolve, animations: {
            self.imageSlide.image = UIImage(named: "\(self.itemDet[self.index].urlImage!)")
            self.animateTextView(name: self.itemDet[self.index].name!)
        }) { (success) in
            if success {
                self.index += 1
                if self.index == self.itemDet.count{
                    self.index = 0
                }
                self.animateImageView()
            }
        }
    }
    
    func animateTextView(name: String){
        UIView.transition(with: self.lblRoom, duration: 3.0, options: .transitionCrossDissolve, animations: {
            self.lblRoom.text = name
        }) { (success) in
            if success {
                self.lblRoom.text = ""
            }
        }
    }
}
