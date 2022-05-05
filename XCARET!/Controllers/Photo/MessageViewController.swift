//
//  MessageViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 4/15/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import MessageUI

protocol MessageViewDelegate {
    func onClose()
}

class MessageViewController: UIViewController {

    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var widthContentConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightContentConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgViewMessage: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewBtnOptions: UIView!
    @IBOutlet weak var btnStyOption1: UIButton!
    @IBOutlet weak var btnStyOption2: UIButton!
    let spacing: CGFloat = 10
    var delegate: MessageViewDelegate? = nil
    
    var typeAlertView : TypeAlertView = .contactCenterView
    var arrayInfo: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.widthContentConstraint.constant = UIScreen.main.bounds.width - 100
        loadAlertView()
    }
    
    func loadAlertView(){
        switch typeAlertView {
        case .invalidCode:
            self.imgViewMessage.image = UIImage(named: "Alert/help")
            self.lblMessage.text = "txt_alert_lyd_not_code".getNameLabel()//"lydNotCode".localized()
        case .unblockAlbum:
            self.imgViewMessage.image = UIImage(named: "Alert/unlock")
            self.lblMessage.attributedText = StringParams.shared.getStringFormat(code: "lblUnlockAlbums", params: arrayInfo)
            self.viewBtnOptions.removeFromSuperview()
            self.heightContentConstraint.constant = (self.viewMessage.bounds.height - self.viewBtnOptions.bounds.height) + 70
        case .excedLimitUnblock:
            self.imgViewMessage.image = UIImage(named: "Alert/unlock")
            self.lblMessage.attributedText = StringParams.shared.getStringFormat(code: "lblExcedUnlock", params: arrayInfo)
            self.viewBtnOptions.removeFromSuperview()
            self.heightContentConstraint.constant = (self.viewMessage.bounds.height - self.viewBtnOptions.bounds.height) + 70
        case .callCenterUnblock:
            self.imgViewMessage.image = UIImage(named: "Alert/help")
            self.lblMessage.text = "txt_alert_lyd_not_code".getNameLabel()//"lydNotCode".localized()
            
            self.btnStyOption1.setImage(UIImage(named: "Icons/ic_correo"), for: .normal)
            self.btnStyOption1.setTitle("Correo", for: .normal)
            self.btnStyOption1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
            self.btnStyOption1.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
            
            self.btnStyOption2.setImage(UIImage(named: "Icons/ic_telefono"), for: .normal)
            self.btnStyOption2.setTitle("Telefono", for: .normal)
            self.btnStyOption2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
            self.btnStyOption2.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
            
        default:
            print("No aplica")
        }
    }

    @IBAction func btnCallMexico(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            
            if typeAlertView == .invalidCode{
                //Llamando desde mexico
                Tools.shared.callNumber(number: "lbl_photo_mexico_phone".getNameLabel())
            }else if typeAlertView == .callCenterUnblock{
                sendEmail(email: "lbl_photo_email_main".getNameLabel())
            }
           
        default:
            if typeAlertView == .invalidCode{
                //Llamando desde el extranjero
                Tools.shared.callNumber(number: "lbl_photo_foreing_phone".getNameLabel())
            }else{
                if Constants.LANG.current == "es" {
                    Tools.shared.callNumber(number: "lbl_photo_mexico_phone".getNameLabel())
                }else{
                    Tools.shared.callNumber(number: "lbl_photo_foreing_phone".getNameLabel())
                }
            }
        }
    }
    
    @IBAction func BtnCloseMessage(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.onClose()
    }
    
    func sendEmail(email : String){
        let toRecipients = [email]
        let subject = "lbl_subject_email".getNameLabel()//"lblSubjectEmail".localized()
        if MFMailComposeViewController.canSendMail() {
            let mail = configuredMailComposeViewController(recipients: toRecipients, subject: subject, body: "", isHtml: true, images: nil)
            presentMailComposeViewController(mailComposeViewController: mail)
        }else if let emailUrl = createEmailUrl(to: email, subject: subject, body: "") {
            UIApplication.shared.open(emailUrl)
        }else{
            print("show failure alert")
            showMailError()
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
           let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
           let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
           
           let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
           let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
           let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
           let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
           let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
           
           if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
               return gmailUrl
           } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
               return outlookUrl
           } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
               return yahooMail
           } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
               return sparkUrl
           }
           
           return defaultUrl
       }
    
    func showMailError() {
        let title = Constants.LANG.current == "en" ? "Could not send email" : "No se pudo enviar el correo electrónico"
        let message = Constants.LANG.current == "en" ? "Your device could not send email to \("lbl_photo_email_main".getNameLabel())" : "Su dispositivo no pudo enviar el correo electrónico a: \("lbl_photo_email_main".getNameLabel()) "
            let sendMailErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
            sendMailErrorAlert.addAction(dismiss)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
}

extension MessageViewController : MFMailComposeViewControllerDelegate{
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
