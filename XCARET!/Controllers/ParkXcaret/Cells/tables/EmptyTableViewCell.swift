//
//  EmptyTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 12/12/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import Lottie

class EmptyTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    //@IBOutlet weak var animateView: LOTAnimatedControl!
    @IBOutlet weak var contenViewEmpty: UIView!
    
    @IBOutlet weak var animateView: AnimationView!
    var imageName: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contenViewEmpty.backgroundColor = .clear
        self.backgroundColor = .clear
        configDarkModeCustom()
    }
    
    func configDarkModeCustom(){
        if appDelegate.itemParkSelected.code == "XF" {
            lblTitle.textColor = .white
        }else{
            lblTitle.textColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setInformation(type: TypeEmptyCell){
        configDarkModeCustom()
        switch type {
        case .notfound:
            lblTitle.text = "lbl_result_not_found".getNameLabel()//"lblResultNotFound".localized()
            imageName = "\(appDelegate.itemParkSelected.code!)busqueda"
            if appDelegate.optionsHome{
                imageName = "busqueda"
            }
        case .searchinfo:
            lblTitle.text = "lbl_search_empty".getNameLabel()//"lblSearchEmpty".localized()
            imageName = "\(appDelegate.itemParkSelected.code!)busqueda"
            if appDelegate.optionsHome{
                imageName = "busqueda"
            }
        case .favorite:
            lblTitle.text = "lbl_add_favorites".getNameLabel()//"lblAddFavorites".localized()
            imageName = "\(appDelegate.itemParkSelected.code!)favorito"
        }
       
        let av = Animation.named(imageName)
        self.animateView.animation = av
        self.animateView.loopMode = .loop
        self.animateView.play()
    }
}
