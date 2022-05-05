//
//  CallCenterHotelViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 7/2/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import MessageUI
import Lottie

class CallCenterHotelViewController: UIViewController {
    
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var heightViewConstraint: NSLayoutConstraint!
    var type: String = "Hotel"
    
    @IBOutlet weak var widthViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewLogo: AnimationView!
    
    @IBOutlet weak var imgCallCenter: UIImageView!
    var listDirectory : [ItemDirectory] = [ItemDirectory]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightViewConstraint.constant = !type.contains("Hotel") ? 200 : 150
        self.widthViewConstraint.constant = UIScreen.main.bounds.width - 100
        self.loadInfo()
        
        if !type.contains("Hotel"){
            self.imgCallCenter.isHidden = true
            let filename = "callcenter"
            let av = Animation.named(filename)
            self.viewLogo.animation = av
            self.viewLogo.loopMode = .loop
            self.viewLogo.contentMode = .scaleToFill //.scaleAspectFit //.scaleAspectFill //.scaleToFill
            self.viewLogo.play()
        }
    }

    @IBAction func btnClose(_ sender: UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
    
    private func loadInfo(){
        //Phones
        if type == "Hotel" {
            listDirectory.append(ItemDirectory(name: "countryMX".localized(), dataInfo: "01800 009 7567", dataSend: "01800-009-7567"))
            listDirectory.append(ItemDirectory(name: "countrySP".localized(), dataInfo: "900 96 52 77", dataSend: "80003413498"))
            listDirectory.append(ItemDirectory(name: "countryBR".localized(), dataInfo: "800 892 3472", dataSend: "8008923472"))
            listDirectory.append(ItemDirectory(name: "countryCO".localized(), dataInfo: "800 034 13498", dataSend: "900965277"))
            listDirectory.append(ItemDirectory(name: "countryCH".localized(), dataInfo: "800 000 118", dataSend: "800000118"))
            listDirectory.append(ItemDirectory(name: "countryPE".localized(), dataInfo: "0 800 00 636", dataSend: "080000636"))
            listDirectory.append(ItemDirectory(name: "countryGR".localized(), dataInfo: "0 800 180 6105", dataSend: "08001806105"))
            listDirectory.append(ItemDirectory(name: "countryUK".localized(), dataInfo: "800 02 94 608", dataSend: "8000294608"))
            listDirectory.append(ItemDirectory(name: "countryIT".localized(), dataInfo: "800 793 295", dataSend: "800793295"))
            listDirectory.append(ItemDirectory(name: "countryFR".localized(), dataInfo: "800 762 00 00", dataSend: "8007620000"))
            listDirectory.append(ItemDirectory(name: "countryEU".localized(), dataInfo: "1 844 795 4525", dataSend: "18447954525"))
            listDirectory.append(ItemDirectory(name: "countryCA".localized(), dataInfo: "1 844 834 0153", dataSend: "18448340153"))
            listDirectory.append(ItemDirectory(name: "",type: .email ,dataInfo: "reservations@hotelxcaret.com", dataSend: "reservations@hotelxcaret.com"))
        }else{
            listDirectory.append(ItemDirectory(name: "cityCUN".localized(),type: .title, dataInfo: "998-883-3143", dataSend: "9988833143"))
            listDirectory.append(ItemDirectory(name: "cityCUN".localized(), dataInfo: "998-883-3143", dataSend: "9988833143"))
            listDirectory.append(ItemDirectory(name: "cityRIV".localized(), dataInfo: "984-206-0038", dataSend: "9842060038"))
            listDirectory.append(ItemDirectory(name: "countryMX".localized(), dataInfo: "01-800-292-2738", dataSend: "01800-292-2738"))
            listDirectory.append(ItemDirectory(name: "countryUSACAN".localized(), dataInfo: "1-855-326-0682", dataSend: "18553260682"))
            listDirectory.append(ItemDirectory(name: "countryAR".localized(), dataInfo: "0800-122-0384", dataSend: "0800-122-0384"))
            listDirectory.append(ItemDirectory(name: "countryBR".localized(), dataInfo: "0-800-892-3371", dataSend: "0-800-892-3371"))
            listDirectory.append(ItemDirectory(name: "countryCO".localized(), dataInfo: "01-800-952-0705", dataSend: "01-800-952-0705"))
            listDirectory.append(ItemDirectory(name: "countrySP".localized(), dataInfo: "900-965-224", dataSend: "900-965-224"))
        }
        
        self.contactTableView.delegate = self
        self.contactTableView.dataSource = self
    }
    
    func sendEmail(email : String){
        if MFMailComposeViewController.canSendMail() {
            let toRecipients = [email]
            let subject = "lbl_subject_email".getNameLabel()//"lblSubjectEmail".localized()
            let mail = configuredMailComposeViewController(recipients: toRecipients, subject: subject, body: "", isHtml: true, images: nil)
            presentMailComposeViewController(mailComposeViewController: mail)
        } else {
            // show failure alert
        }
    }
}

extension CallCenterHotelViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDirectory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemDirectory = listDirectory[indexPath.row]
        if itemDirectory.type == .title {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellSchedule", for: indexPath) as! ItemScheduleAtentionTableViewCell
            cell.configTableCell()
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellContact", for: indexPath) as! ItemContactHotelTableViewCell
            cell.configTableCell(itemDirectory: listDirectory[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listDirectory[indexPath.row].type == .phone{
            Tools.shared.callNumber(number: listDirectory[indexPath.row].dataSend)
        }else if listDirectory[indexPath.row].type == .email{
            sendEmail(email: listDirectory[indexPath.row].dataSend)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemDirectory = listDirectory[indexPath.row]
        if itemDirectory.type == .title {
            return UITableView.automaticDimension
        }else{
            return 30
        }
        
    }
}

extension CallCenterHotelViewController : MFMailComposeViewControllerDelegate{
    func configuredMailComposeViewController(recipients : [String]?, subject :
        String, body : String, isHtml : Bool = false,
                images : [UIImage]?) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // IMPORTANT
        mailComposerVC.setToRecipients(recipients)
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(body, isHTML: isHtml)
        
        
        return mailComposerVC
    }
    
    func presentMailComposeViewController(mailComposeViewController :
        MFMailComposeViewController) {
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController,
                         animated: true, completion: nil)
        } else {
            let sendMailErrorAlert = UIAlertController.init(title: "lbl_error".getNameLabel()/*"lblError".localized()*/,
                                                            message: "lbl_error_email".getNameLabel()/*"lblErrorEmail".localized()*/, preferredStyle: .alert)
            self.present(sendMailErrorAlert, animated: true,
                         completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result) {
        case .cancelled:
            self.dismiss(animated: true, completion: nil)
        case .sent:
            self.dismiss(animated: true, completion: nil)
        case .failed:
            self.dismiss(animated: true, completion: {
                let sendMailErrorAlert = UIAlertController.init(title: "lbl_error_failed".getNameLabel()/*"lblErrorFailed".localized()*/,
                                                                message: "lbl_error_email".getNameLabel()/*"lblErrorEmail".localized()*/, preferredStyle: .alert)
                sendMailErrorAlert.addAction(UIAlertAction.init(title: "OK",
                                                                style: .default, handler: nil))
                self.present(sendMailErrorAlert,
                             animated: true, completion: nil)
            })
        default:
            break;
        }
    }
}
