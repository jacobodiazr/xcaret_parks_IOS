//
//  ContentProgramCollectionViewCell.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 07/06/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class ContentProgramCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var widhtLayoutConstraint: NSLayoutConstraint!
    var consecutivo: Int! = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.numero.layer.masksToBounds = true
        self.numero.layer.cornerRadius = 10
        self.contentView.dropShadow(color: UIColor.gray, opacity: 0.2, offSet: CGSize(width: 0, height: 3), radius: 2, scale: true, corner: 20, backgroundColor: UIColor.clear)
        // Initialization code
    }
    
    func configureCell(ItemContentPrograms : ItemContentPrograms, numero: Int){
        
        let imagen: UIImage? = UIImage(named: "ProgramaDeMano/escenas/\(ItemContentPrograms.cont_imagen!)")
        if imagen != nil {
           self.img.image = imagen
        }else{
            self.img.image = UIImage(named: "ProgramaDeMano/escenas/default")
        }
        
        print(appDelegate.contentPrograms.getDetail.name)
        print(appDelegate.contentPrograms.lang!)
        
        self.descripcion.text = ItemContentPrograms.getDetail.name
        self.numero.text = String(numero + 1)
        
//        widhtLayoutConstraint.constant = (UIScreen.main.bounds.width) * 0.27
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                contenView.dropShadow(color: UIColor(red: 128/255, green: 12/255, blue: 14/255, alpha: 1.00), opacity: 0.9, offSet: CGSize(width: -1, height: 1), radius:3, scale: true, corner: 10, backgroundColor: UIColor.clear)
            }else{
                contenView.dropShadow(color: UIColor.gray, opacity: 0.0, offSet: CGSize(width: 0, height: 5), radius:3, scale: true, corner: 20, backgroundColor: UIColor.clear)
                
            }
        }
    }
}
