//
//  ItemBuyTableViewCell.swift
//  XCARET!
//
//  Created by YEiK on 17/08/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import Lottie

class ItemBuyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameProductoLbl: UILabel!
    @IBOutlet weak var mensajeErrorLbl: UILabel!
    @IBOutlet weak var animationBuy: AnimationView!
    @IBOutlet weak var constraintMensaje: NSLayoutConstraint!
    
    enum ProgressKeyFrames: CGFloat {
        case start = 0
        case end = 60
        
        case successStart = 61
        case successEnd = 90
        
        case failStart = 91
        case failEnd = 120
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        mensajeErrorLbl.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configLottie(itemCarshop : ItemCarshop, status : String) {
        constraintMensaje.constant = 0
        mensajeErrorLbl.isHidden = true
        let filename = "reserva"
        let av = Animation.named(filename)
        self.animationBuy.animation = av
        
        if itemCarshop.statusBuy.enProceso {
            self.animationBuy.loopMode = .loop
            animationBuy.play(fromFrame: ProgressKeyFrames.start.rawValue, toFrame: ProgressKeyFrames.end.rawValue, loopMode: .loop)
            nameProductoLbl.alpha = 1
            animationBuy.alpha = 1
            nameProductoLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        }else{
            switch itemCarshop.statusBuy.statusVenta {
            case .approved, .paymentPlan:
                print("Tu compra se realizo correctamente.")
                nameProductoLbl.font = UIFont.systemFont(ofSize: 16.0)
                animationBuy.play(fromFrame: ProgressKeyFrames.successStart.rawValue, toFrame: ProgressKeyFrames.successEnd.rawValue, loopMode: .playOnce)
            case .inProcess:
                print("Estamos validando tu pago.")
                nameProductoLbl.font = UIFont.systemFont(ofSize: 16.0)
                animationBuy.play(fromFrame: ProgressKeyFrames.successStart.rawValue, toFrame: ProgressKeyFrames.successEnd.rawValue, loopMode: .playOnce)
            case .declined, .rejected:
                print("Transacción denegada, por favor contacte a su banco.")
                mensajeErrorLbl.isHidden = false
                mensajeErrorLbl.text = "lbl_buy_transaction_denied".getNameLabel()
                nameProductoLbl.font = UIFont.systemFont(ofSize: 16.0)
                constraintMensaje.constant = -8
                animationBuy.play(fromFrame: ProgressKeyFrames.failStart.rawValue, toFrame: ProgressKeyFrames.failEnd.rawValue, loopMode: .playOnce)
            case .errorCarShop:
                print("Error al validar tu producto, intentelo más tarde")
                mensajeErrorLbl.isHidden = false
                mensajeErrorLbl.text = "lbl_buy_error_validating".getNameLabel()
                nameProductoLbl.font = UIFont.systemFont(ofSize: 16.0)
                constraintMensaje.constant = -8
                animationBuy.play(fromFrame: ProgressKeyFrames.failStart.rawValue, toFrame: ProgressKeyFrames.failEnd.rawValue, loopMode: .playOnce)
            default:
                if itemCarshop.statusBuy.id != "" && itemCarshop.statusBuy.idTicket != "" {
                    mensajeErrorLbl.isHidden = false
                    mensajeErrorLbl.text = "lbl_buy_transaction_denied".getNameLabel()
                    nameProductoLbl.font = UIFont.systemFont(ofSize: 16.0)
                    animationBuy.play(fromFrame: ProgressKeyFrames.failStart.rawValue, toFrame: ProgressKeyFrames.failEnd.rawValue, loopMode: .playOnce)
                }
//                else{
//                    mensajeErrorLbl.isHidden = false
//                    mensajeErrorLbl.text = "Ocurrio un error, intente de nuevo"
//                    nameProductoLbl.font = UIFont.systemFont(ofSize: 16.0)
//                    animationBuy.play(fromFrame: ProgressKeyFrames.failStart.rawValue, toFrame: ProgressKeyFrames.failEnd.rawValue, loopMode: .playOnce)
//                }
            }
            

        }
        nameProductoLbl.text = itemCarshop.products.first?.productName.capitalized
    }

}
