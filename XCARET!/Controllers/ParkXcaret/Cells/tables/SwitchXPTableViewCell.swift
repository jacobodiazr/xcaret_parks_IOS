//
//  SwitchXPTableViewCell.swift
//  XCARET!
//
//  Created by Jacobo Díaz on 11/12/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import Lottie


class SwitchXPTableViewCell: UITableViewCell {
    weak var homeViewController : HomeViewController?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblXplore: UILabel!
    @IBOutlet weak var lblHrsXplore: UILabel!
    @IBOutlet weak var lblXploreFuego: UILabel!
    @IBOutlet weak var lblHrsXploreFuego: UILabel!
    @IBOutlet weak var animateView: AnimationView!
    @IBOutlet weak var viewXPAction: UIView!
    @IBOutlet weak var viewXPFAction: UIView!
    @IBOutlet weak var viewContentSwich: UIView!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    var dia = true
    override func awakeFromNib() {
        super.awakeFromNib()
        let av = Animation.named("switchXP")
        self.animateView.animation = av
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureCheckActionDia = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionDia))
        let gestureCheckActionNoche = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionNoche))
        self.animateView.addGestureRecognizer(gesture)
        self.viewXPAction.addGestureRecognizer(gestureCheckActionNoche)
        self.viewXPFAction.addGestureRecognizer(gestureCheckActionDia)
        if appDelegate.itemParkSelected.code == "XF" {
            animateView.animationSpeed = 30.0
            animateView.play()
            dia = false
        }else{
            dia = true
        }
        self.lblTitle.text = "lbl_select_you_adventure".getNameLabel()//"lblTitleChooseXP".localized()
        self.lblDescription.text = "lbl_select_description".getNameLabel()//"lblDescriptionChooseXP".localized()
        self.configStyleModeSwitch()
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        if dia {
            animateView.animationSpeed = 2.0
            animateView.play()
            dia = false
            homeViewController?.reloadTableXP(dia: dia)
        }else{
            animateView.animationSpeed = 2.0
            animateView.play(fromProgress: 1, toProgress: 0)
            dia = true
            homeViewController?.reloadTableXP(dia: dia)
        }
        self.configStyleModeSwitch()
    }
    
    @objc func checkActionDia(sender : UITapGestureRecognizer) {
        if dia {
            animateView.animationSpeed = 2.0
            animateView.play()
            dia = false
            homeViewController?.reloadTableXP(dia: dia)
            self.configStyleModeSwitch()
        }
    }
    
    @objc func checkActionNoche(sender : UITapGestureRecognizer) {
        if !dia {
            animateView.animationSpeed = 2.0
            animateView.play(fromProgress: 1, toProgress: 0)
            dia = true
            homeViewController?.reloadTableXP(dia: dia)
            self.configStyleModeSwitch()
        }
    }
    
    func configStyleModeSwitch(){
        if appDelegate.itemParkSelected.code == "XF" {
            //            animateView.animationSpeed = 30.0
            //            animateView.play()
            lblXplore.textColor = .white
            lblHrsXplore.textColor = .white
            lblXploreFuego.textColor = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
            lblHrsXploreFuego.textColor = .white
            lblTitle.textColor = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
            lblHrsXploreFuego.textColor = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
            lblXploreFuego.font = UIFont.boldSystemFont(ofSize: 16.0)
            lblXplore.font = UIFont.systemFont(ofSize: 15.0)
            lblDescription.textColor = .white
            lblHrsXplore.font = UIFont.systemFont(ofSize: 12.0)
            lblHrsXploreFuego.font = UIFont.boldSystemFont(ofSize: 12.0)
            dia = false
        }else{
            lblXplore.font = UIFont.boldSystemFont(ofSize: 16.0)
            lblHrsXplore.font = UIFont.systemFont(ofSize: 12, weight: .black)
            lblXploreFuego.font = UIFont.systemFont(ofSize: 15.0)
            lblHrsXploreFuego.font = UIFont.boldSystemFont(ofSize: 12.0)
            lblTitle.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
            lblXploreFuego.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
            lblXplore.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
            lblDescription.textColor = UIColor(red: 140/255, green: 157/255, blue: 175/255, alpha: 1.0)
            lblHrsXplore.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
            lblHrsXploreFuego.textColor = UIColor(red: 140/255, green: 157/255, blue: 175/255, alpha: 1.0)
            dia = true
        }
        //appDelegate.itemParkSelected.code
        if Tools.shared.isFormatHours24() {
            lblHrsXplore.text = "xp_lbl_schedule_24".getNameLabel()//"\(appDelegate.itemParkSelected.code.lowercased())_lbl_schedule_24".getNameLabel()//"lblhrs24XP".localized()
            lblHrsXploreFuego.text = "xf_lbl_schedule_24".getNameLabel()//"lblhrs24XF".localized()
        }else{
            lblHrsXplore.text = "xp_lbl_schedule_12".getNameLabel()//"lblhrs12XP".localized()
            lblHrsXploreFuego.text = "xf_lbl_schedule_12".getNameLabel()//"lblhrs12XF".localized()
        }
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        self.animateView.loopMode = .loop
//        self.animateView.play()
        // Configure the view for the selected state
//    }
    
}
