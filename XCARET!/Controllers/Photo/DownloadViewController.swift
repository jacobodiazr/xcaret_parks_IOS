//
//  DownloadViewController.swift
//  XCARET!
//
//  Created by Jose Eduardo Cardenas Montero on 07/04/22.
//  Copyright © 2022 Angelica Can. All rights reserved.
//

import UIKit
import Firebase

protocol DownloadViewDelegate{
    func download()
    func successSend()
}

class DownloadViewController: UIViewController {

    @IBOutlet weak var lblRecomendationWifi: UILabel!
    @IBOutlet weak var lblDownloadSize: UILabel!
    @IBOutlet weak var btnSaveToDevice: UIButton!
    @IBOutlet weak var lblStorageSpace: UILabel!
    @IBOutlet weak var lblSendToEmail: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnClose: UIImageView!
    let averageFileSizeDefault = 2.0
    var averageFileSize = 0.0
    var delegate: DownloadViewDelegate?
    var albumDetail: ItemAlbumDetail!
    var album: ItemAlbum!
    override func viewDidLoad() {
        super.viewDidLoad()

        var totalDownload = 0.0
        if averageFileSize > 0.0 {
            totalDownload = (averageFileSize * Double(albumDetail.totalMedia)) / 1024.0
        } else {
            totalDownload = (averageFileSizeDefault * Double(albumDetail.totalMedia)) / 1024.0
        }
        
        let freeDiskSpace = (Double(DiskStatus.freeDiskSpaceInBytes) / 1024.0 ) / 1024.0
        btnSaveToDevice.isEnabled = freeDiskSpace > totalDownload
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onClose(tapGestureRecognizer:)))
        btnClose.isUserInteractionEnabled = true
        btnClose.addGestureRecognizer(tapGestureRecognizer)
        
        lblRecomendationWifi.text = "lbl_wifi_recommendation".getNameLabel()
        lblDownloadSize.text = "lbl_download_size".getNameLabel() + " " + String(format: "%.2f", totalDownload) + "GB"
        btnSaveToDevice.setTitle("lbl_save_to_device".getNameLabel(), for: .normal)
        lblStorageSpace.text = "lbl_storage_space".getNameLabel() + " " + DiskStatus.freeDiskSpace
        lblSendToEmail.text = "lbl_optional".getNameLabel()
        btnSend.setTitle("lbl_send".getNameLabel(), for: .normal)
        tfEmail.text = getInfoUserAuth().email
    }
    
    
    @IBAction func onClickSaveInDevice(_ sender: Any) {
        self.dismiss(animated: true)
        delegate?.download()
    }
    
    @IBAction func onClickSendToEmail(_ sender: Any) {
        if tfEmail.isValidEmailAddress() {
            LoadingView.shared.showActivityIndicator(uiView: self.view)
            let email = tfEmail.text?.trimmingCharacters(in: .whitespaces) ?? ""
            PhotoBR.shared.sendUrl(email: email, photoCode: album.code ?? "") { success in
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                if success {
                    self.delegate?.successSend()
                    self.dismiss(animated: true)
                } else {
                    UpAlertView(type: .error, message: "lbl_fail_send_desc".getNameLabel()).show {
                        //print("Falta Información")
                    }
                }
            }
        } else {
            UpAlertView(type: .error, message: "txt_alert_email".getNameLabel()).show {
                print("Falta Información")
            }
        }
    }
    
    @objc func onClose(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: true)
    }
    
    private func getInfoUserAuth() -> UserApp{
        let userApp : UserApp = UserApp()
        let userAuth = Auth.auth().currentUser
        
        if userAuth != nil {
            if let userIdUser = userAuth?.uid{
                userApp.uid = userIdUser
            }
            
            if (userAuth?.isAnonymous)! {
                let name = ((Constants.LANG.current == "es") ? "Invitado" : "Guest")
                userApp.name = name
                userApp.email = "\(name.lowercased().replacingOccurrences(of: "ó", with: "o"))@\(Date().string(format: "yyyyMMddHHmmss"))"
                userApp.provider = (userAuth?.providerID)!
            }else{
                if let providerUser = userAuth?.providerData[0].providerID {
                    userApp.provider = providerUser
                }
                
                if let emailUser = userAuth?.providerData[0].email{
                    userApp.email = emailUser
                }
                if let nameUser = userAuth?.providerData[0].displayName {
                    userApp.name = nameUser
                }
                if let phoneUser = userAuth?.providerData[0].phoneNumber {
                    userApp.phone = phoneUser
                }
                if let photoProfile = userAuth?.providerData[0].photoURL{
                    print("url Photo\(photoProfile)")
                }
            }
        }
        return userApp
    }
    
    
}
