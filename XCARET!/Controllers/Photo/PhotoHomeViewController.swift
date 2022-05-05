//
//  PhotoHomeViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 3/27/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class PhotoHomeViewController: UIViewController {
    var textFields: [UITextField]!
    
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var viewCode: UIView!
    @IBOutlet weak var viewCodeBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCodeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnValidateCodeStyle: UIButton!
    @IBOutlet weak var lblLeyend: UILabel!
    @IBOutlet weak var imgViewBackGround: UIImageView!
    @IBOutlet weak var bottonCode: NSLayoutConstraint!
    
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var tblAlbum: UITableView! {
        didSet{
            tblAlbum.register(UINib(nibName: "ItemAlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "cellAlbum")
            tblAlbum.register(UINib(nibName: "ItemAlbumExpiredTableViewCell", bundle: nil), forCellReuseIdentifier: "cellExpired")
            tblAlbum.delegate = self
            tblAlbum.dataSource = self
        }
    }
    
    @IBOutlet weak var lblNoteBottomConstraint: NSLayoutConstraint!
    
    var isIphoneX : Bool = false
    var countErrors : Int = 0
    var listAlbum : [ItemAlbum] = [ItemAlbum]()
    //var codeAlbum : String = ""
    //var parkId : Int = 0
    var parkName : String = ""
    var infoAlbum : ItemAlbum = ItemAlbum()
    var itemSelected : ItemAlbumDetail = ItemAlbumDetail()
    var typeAlert : TypeAlertView!
    var infoMessage : [String] = [String]()
    var showKeyboard = false
    var first = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "lbl_title_albums".getNameLabel().uppercased()//"titleAlbums".localized().uppercased()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Photo/Background/navbar"), for: UIBarMetrics.default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.isTranslucent = false
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "Icons/photo/ic_regresar"), style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "Colors/link")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        textFields = [txtCode]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboards))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        self.viewCodeHeightConstraint.constant = UIDevice().getHeightViewCode()
        print("viewCodeHeightConstraint \(self.viewCodeHeightConstraint.constant)")
        self.txtCode.placeholder = "lbl_place_holder_code".getNameLabel()//"placeHolderCode".localized()
        self.lblLeyend.text = "lbl_leyend_not_albums".getNameLabel()//"lblLeyendNotAlbums".localized()
        
        if appDelegate.enviromentProduction == TypeEnviroment.develop{
            self.txtCode.text = "XPMQ9R4NCZLF"
        }
        
        txtCode.delegate = self
        txtCode.tag = 0
        txtCode.returnKeyType = .done
        
        loadNote()
        loadInformation()
        
        /* PARA PRUEBAS DEL ALERT
        self.typeAlert = .unblockAlbum
        self.infoMessage = ["2", "0"]
        self.performSegue(withIdentifier: "goInvalidCode", sender: nil)*/
    }
    
    @objc func dismissKeyboards() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.showKeyboard = false
        self.bottonCode.constant = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBarStyle(.default)
    }
    
    func loadNote(){
        let boldText  = "notePhoto".localized()
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        let normalText = "lbl_info_note_photo".getNameLabel()//"infoNotePhoto".localized()
        let normalAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let normalString = NSMutableAttributedString(string:normalText, attributes: normalAttrs)
        
        attributedString.append(normalString)
        self.lblNote.attributedText = attributedString
        self.lblNoteBottomConstraint.constant = UIDevice().getBottomLeyend()
    }
    
    func loadInformation(){
        LoadingView.shared.showActivityIndicator(uiView: self.view, type: .loadPhoto)
        FirebaseBR.shared.getAlbums {
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            self.listAlbum = appDelegate.listAlbum
            if self.listAlbum.count > 0 {
                self.imgViewBackGround.isHidden = true
                self.lblLeyend.isHidden = true
                self.tblAlbum.isHidden = false
            }else{
                self.imgViewBackGround.isHidden = false
                self.lblLeyend.isHidden = false
                self.tblAlbum.isHidden = true
            }
            self.tblAlbum.reloadData()
        }
    }
    
    @objc public func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard(_sender : UITapGestureRecognizer){
        self.view.endEditing(true)
        txtCode.resignFirstResponder()
        print("validar codigo")
    }
    
    @IBAction func btnValidateCode(_ sender: UIButton) {
        print("validar codigo")
        AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Photo.rawValue, title: TagsPhoto.validateCode.rawValue)
        txtCode.resignFirstResponder()
        LoadingView.shared.showActivityIndicator(uiView: self.view, type: .loadPhoto)
        let codeValid = self.txtCode.text?.trimmingCharacters(in: .whitespaces)
        PhotoBR.shared.existCodeFB(code: codeValid!) { (exist) in
            if !exist{
                PhotoBR.shared.validateCode(code: codeValid!) { (isvalid, albumList) in
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    if isvalid {
                        self.txtCode.text = ""
                        self.btnValidateCodeStyle.isEnabled = false
                        self.btnValidateCodeStyle.backgroundColor =  Constants.COLORS.PHOTOPASS.btnDisabledValidateCode
                        if albumList.isBook {
                            if albumList.totalUnlock >= albumList.totalPurchase{
                                self.typeAlert = .excedLimitUnblock
                                self.infoMessage = ["\(albumList.totalPurchase ?? 0)","\(albumList.totalUnlock ?? 0)", "\(albumList.totalRest ?? 0)"]
                            }else{
                                self.typeAlert = .unblockAlbum
                                self.infoMessage = ["\(albumList.totalPurchase ?? 0)", "\(albumList.totalUnlock ?? 0)", "\(albumList.totalRest ?? 0)"]
                            }
                            self.performSegue(withIdentifier: "goInvalidCode", sender: nil)
                        }
                        self.tblAlbum.isHidden = false
                    }else{
                        self.countErrors += 1
                        if self.countErrors == 1 {
                            UpAlertView(type: .error, message: "lydNotFoundAlbum".localized()).show(completion: {
                                print("Mostrar otro coso")
                            })
                        }else{
                            self.typeAlert = .invalidCode
                            self.performSegue(withIdentifier: "goInvalidCode", sender: nil)
                        }
                    }
                }
            }else{
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                UpAlertView(type: .warning, message: "lyd_code_exist".getNameLabel()/*"lydCodeExist".localized()*/).show(completion: {
                    print("Mostrar otro coso")
                })
            }
        }
    }
    
    @objc func keyboardWillchange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            self.setScrollViewPosition(keyboardRect: keyboardRect.height)
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
         print(self.view.frame.origin.y) // Move view to original position
    }
    
    
    
    func setScrollViewPosition(keyboardRect: CGFloat){
        //Calculamos la altura de la pantalla
        let screenSize : CGRect = UIScreen.main.bounds
        let screenHeight : CGFloat = screenSize.height
        
        for textField in textFields {
            if textField.isFirstResponder {
                print(textField.placeholder!)
                // Calculamos la 'Y' máxima del UITextField
                let yPositionField = viewCode.frame.origin.y
                let heightField = viewCode.frame.size.height
                let yPositionMaxField = yPositionField + heightField
                // Calculamos la 'Y' máxima del View que no queda oculta por el teclado
                let Ymax = screenHeight - keyboardRect
                // Comprobamos si nuestra 'Y' máxima del UITextField es superior a la Ymax
                if yPositionMaxField > Ymax{
                    self.viewCodeBottomConstraint.constant = keyboardRect
                    if UIDevice().getiPhoneX(){
                            self.viewCodeHeightConstraint.constant = 50
                            self.bottonCode.constant = keyboardRect
                    }
                }else{
                    if UIDevice().getiPhoneX(){
                        if first {
                            self.bottonCode.constant = 50 + keyboardRect
                        }
                        if !showKeyboard {
                            self.bottonCode.constant = keyboardRect
                            if first {
                                showKeyboard = false
                            }else{
                                showKeyboard = true
                            }
                        }else{
                            self.bottonCode.constant = 0
                            self.viewCodeHeightConstraint.constant = 70
                        }
                        if first {
                            self.bottonCode.constant = 50 + keyboardRect
                            self.first = false
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAlbumPhotos" {
            if let albumController = segue.destination as? AlbumViewController {
                albumController.infoAlbum = self.infoAlbum
                albumController.itemAlbumList = self.itemSelected
                
            }
        }else if segue.identifier == "goInvalidCode"{
            if let messageController = segue.destination as? MessageViewController {
                messageController.typeAlertView = typeAlert
                messageController.arrayInfo = self.infoMessage
            }
        }
    }
}


extension PhotoHomeViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        textField.text = textFieldText.uppercased()
        if string == " " {
            return false
        }else{
            if count >= 12 {
                self.btnValidateCodeStyle.isEnabled = true
                self.btnValidateCodeStyle.backgroundColor =  Constants.COLORS.PHOTOPASS.btnEnabledValidateCode
            }else{
                self.btnValidateCodeStyle.isEnabled = false
                self.btnValidateCodeStyle.backgroundColor =  Constants.COLORS.PHOTOPASS.btnDisabledValidateCode
            }
            return count <= 15
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Aceptar \(txtCode.text!.count)")
        if txtCode.text!.count >= 12 {
            txtCode.resignFirstResponder()
            self.bottonCode.constant = 0
            return true
        } else {
            if UIDevice().getiPhoneX(){
                self.bottonCode.constant = 0
                self.view.endEditing(true)
                return true
            }else{
                self.bottonCode.constant = 0
                self.view.endEditing(true)
                return true
            }
            
        }
    }
}

extension PhotoHomeViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listAlbum.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAlbum[section].listAlbumesDet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemAlbum: ItemAlbum = listAlbum[indexPath.section]
        if itemAlbum.statusAlbum == TypeAlbumStatus.expired{
            let cell : ItemAlbumExpiredTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellExpired", for: indexPath) as! ItemAlbumExpiredTableViewCell
            cell.configureCell(isBook: listAlbum[indexPath.section].isBook, itemDetail: listAlbum[indexPath.section].listAlbumesDet[indexPath.row])
            return cell
        }else{
            let cell : ItemAlbumTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellAlbum", for: indexPath) as! ItemAlbumTableViewCell
            cell.configureCell(isBook: listAlbum[indexPath.section].isBook, itemAlbum: itemAlbum, itemDetail: listAlbum[indexPath.section].listAlbumesDet[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let itemAlbum = listAlbum[section]
        var textHeader : String = ""
        if itemAlbum.isBook{
            if itemAlbum.totalPurchase == itemAlbum.totalUnlock {
                textHeader = "#\(itemAlbum.code!)"
            }else{
                textHeader = String(format: "lydHeaderAlbum".localized(), arguments: ["\(itemAlbum.totalPurchase!)", "\(itemAlbum.totalRest!)", itemAlbum.code])
            }
        }else{
            textHeader = "#\(itemAlbum.code!)"
        }
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 35))
        headerView.backgroundColor = Constants.COLORS.PHOTOPASS.bckHeader
        let label = UILabel() 
        label.frame = CGRect.init(x: 5, y: 8, width: headerView.frame.width-15, height: headerView.frame.height-15)
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        label.text = textHeader
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemAlbum = listAlbum[indexPath.section]
        if itemAlbum.statusAlbum != TypeAlbumStatus.expired{
            self.infoAlbum = itemAlbum
            self.itemSelected = itemAlbum.listAlbumesDet[indexPath.row]
            self.performSegue(withIdentifier: "goAlbumPhotos", sender: nil)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //193
    }
    
}


