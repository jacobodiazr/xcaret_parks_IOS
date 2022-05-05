//
//  AlbumViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 4/10/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import PMAlertController
import Kingfisher

class AlbumViewController: UIViewController {

    @IBOutlet weak var collectionAlbum: UICollectionView!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewMenuHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var viewShared: UIView!
    @IBOutlet weak var viewShareHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnStyAlbum: UIButton!
    @IBOutlet weak var btnStySelected: UIButton!
    @IBOutlet weak var viewSharedBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnStyUnlock: UIButton!
    @IBOutlet weak var btnStyCancel: UIButton!
    @IBOutlet weak var btnStyShare: UIButton!
    
    var isBook: Bool!
    var itemAlbumList : ItemAlbumDetail!
    var infoAlbum : ItemAlbum!
    var listPhotos : [ItemPhoto] = [ItemPhoto]()
    var indexPathPhoto : IndexPath!
    var selectedCells : NSMutableArray = []
    var selectedRows : [Int] = []
    var modeShare : Bool = false
    var infoMessage : [String] = [String]()
    var typeAlert : TypeAlertView!
    var rightButton: UIBarButtonItem!
    var fileSizeFirstPhoto = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.navigationItem.setHidesBackButton(true, animated: true)
        self.collectionAlbum.contentInsetAdjustmentBehavior = .never
        let leftButton = UIBarButtonItem(image: UIImage(named: "Icons/photo/ic_regresar"), style: .plain, target: self, action: #selector(goBack))
        leftButton.isEnabled = false
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "Colors/link")
        
        rightButton = UIBarButtonItem(title: "lbl_select_photo".getNameLabel(), style: .plain, target: self, action: #selector(toggleSelectPhotos))
        rightButton.tintColor = UIColor(named: "Colors/link")
        rightButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.viewMenuHeightContraint.constant = UIDevice().getHeightViewCode()
        self.viewShareHeightConstraint.constant = UIDevice().getHeightViewCode()
        self.getAlbum()
        self.configurationMenu()
    }
    
    @objc public func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBarStyle(.default)
        let namePark = FirebaseBR.shared.getNamePark(parkId: self.itemAlbumList.parkId)//self.itemAlbumList.getNameByParkId
        //self.title = "\("lbl_title_albums".getNameLabel()) \(namePark.uppercased())"//String(format: "titlePhotosByAlbum".localized(), arguments: [namePark]).uppercased()
        self.title = namePark.uppercased()
    }
    
    override func viewDidLayoutSubviews() {
        self.btnStySelected.alignVertical(spacing: 0)
        self.btnStyAlbum.alignVertical(spacing: 0)
    }
    
    func configurationMenu(){
        //self.btnStySelected.setTitle("btn_tab_share".getNameLabel()/*"btnTabShare".localized()*/, for: .normal)
        self.btnStyAlbum.setTitle("lbl_select_photo_all".getNameLabel()/*"btnTabAlbum".localized()*/, for: .normal)
        self.btnStyShare.setTitle("btn_tab_share".getNameLabel()/*"bntShare".localized()*/, for: .normal)
        self.btnStyShare.isEnabled = false
        self.btnStyShare.isUserInteractionEnabled = false
        self.viewMenu.isHidden = true
        self.viewMenuHeightContraint.constant = 0
        //self.btnStyCancel.setTitle("lbl_cancel".getNameLabel()/*"btnCancel".localized()*/, for: .normal)
        //self.btnStyShare.isEnabled = false
    }
    
    func getAlbum(){
        if self.infoAlbum.code != nil && self.itemAlbumList.parkId != nil {
            LoadingView.shared.showActivityIndicator(uiView: self.view, type: .loadPhoto)
            PhotoBR.shared.getPhoto(code: self.infoAlbum.code, parkId: self.itemAlbumList.parkId) { (listPhotos) in
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                if listPhotos.count > 0 {
                    self.getFileSize(path: listPhotos.first?.orig ?? "")
                    self.listPhotos = listPhotos
                    self.collectionAlbum.dataSource = self
                    self.collectionAlbum.delegate = self
                    self.collectionAlbum.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
                     self.listenerStatusAlbum()
                }else{
                    self.btnStySelected.isEnabled = false
                    self.typeAlert = .callCenterUnblock
                    self.infoMessage = ["8", "2"]
                    self.performSegue(withIdentifier: "goAlbumToMessage", sender: nil)
                }
            }
        }
    }
    
    func listenerStatusAlbum(){
        FirebaseBR.shared.getStatusAlbumDetail(code: self.infoAlbum.code, uidAlbumDet: self.itemAlbumList.uid, totalMediaReal: self.listPhotos.count) { (statusItem) in
            self.itemAlbumList = statusItem
            //Si el album está desbloqueado se puede compartir
            self.btnStySelected.isEnabled = self.itemAlbumList.unlock
            self.btnStyUnlock.isHidden = self.itemAlbumList.unlock
            self.navigationItem.rightBarButtonItem?.isEnabled = self.itemAlbumList.unlock
            self.collectionAlbum.reloadData()
        }
    }
    
    @IBAction func btnSelectAll(_ sender: UIButton) {
        if modeShare && self.itemAlbumList.unlock {
            if selectedRows.count < self.itemAlbumList.totalMedia {
                selectedRows.removeAll()
                for (index, photo) in listPhotos.enumerated() {
                    photo.isSelected = true
                    self.selectedRows.append(index)
                }
                collectionAlbum.reloadData()
                self.btnStyAlbum.setTitle("lbl_dis_select_photo".getNameLabel(), for: .normal)
                self.btnStyShare.isEnabled = true
            } else {
                btnStyShare.isEnabled = false
                selectedRows.removeAll()
                collectionAlbum.reloadData()
                self.btnStyAlbum.setTitle("lbl_select_photo_all".getNameLabel(), for: .normal)
            }
        }
    }
    
    @IBAction func btnSelectedPhotos(_ sender: UIButton) {
        self.modeShare = true
        //showHideViewShare()
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.disableModeShare()
        self.btnStyShare.isEnabled = false
    }
    
    @IBAction func btnSharePhoto(_ sender: UIButton) {
        guard btnStyShare.isEnabled else{
            return
        }
        if selectedRows.count >= self.itemAlbumList.totalMedia {
            performSegue(withIdentifier: "showDownload", sender: nil)
        } else {
            shareImages()
        }
    }
    
    func shareImages() {
        LoadingView.shared.showActivityIndicator(uiView: self.view, type: .loadPhoto)
        downloadAndShareImages { (listImg, listPhotosSelected) in
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            if listImg.count > 0 {
                let activityViewController = UIActivityViewController(activityItems: listImg , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.completionWithItemsHandler = { activity, success, items, error in
                    if success{
                        FirebaseDB.shared.saveInteractionPhoto(code: self.infoAlbum.code , albumUID: self.itemAlbumList.uid!, listPhotos: listPhotosSelected, completion: { (success) in
                            if success{
                                AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Photo.rawValue, title: TagsPhoto.shareMultiPhotos.rawValue)
                                self.disableModeShare()
                                self.rightButton.title = "lbl_select_photo".getNameLabel()
                                //self.btnStyShare.isEnabled = false
                            }
                        })
                        
                    }else{
                        print("Se canceló????")
                    }
                }
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnUnlockAlbum(_ sender: UIButton) {
        //Validamos que pueda desbloquear albumes
        if self.infoAlbum.totalUnlock < self.infoAlbum.totalPurchase{
            let messagetextAttribute = StringParams.shared.getStringFormat(code: "lblUnlockAlbums", params: ["\(self.infoAlbum.totalPurchase!)", "\(self.infoAlbum.totalUnlock!)" ,"\(self.infoAlbum.totalRest!)"])
            let desc = messagetextAttribute.mutableString as String
            let alertVC = PMAlertController(title: "", description: desc,  image: UIImage(named: "Alert/unlock"), style: .alert)
            alertVC.headerViewTopSpaceConstraint.constant = 0
            alertVC.headerView.backgroundColor = UIColor.gray
            alertVC.alertView.cornerRadius = 20
            alertVC.headerView.cornerRadius = 20
            alertVC.headerViewHeightConstraint.constant = 130
            alertVC.alertImage.cornerRadius = 20
//            alertVC.alertImage.contentMode = .scaleAspectFill
            alertVC.view.layoutIfNeeded()
            alertVC.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
            alertVC.addAction(PMAlertAction(title: "lbl_cancel".getNameLabel()/*"lblCancel".localized()*/, style: .default, action: { () in
                print("Cancel")
            }))
            alertVC.addAction(PMAlertAction(title: "lbl_accept".getNameLabel()/*"lblAccept".localized()*/, style: .default, action: { () in
                print("Accept")
                
                LoadingView.shared.showActivityIndicator(uiView: self.view, type: .loadPhoto)
                PhotoBR.shared.saveAlbumUnlock(code: self.infoAlbum.code, parkId: self.itemAlbumList.parkId) { (success) in
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    if success{
                        AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Photo.rawValue, title: TagsPhoto.unlockAlbum.rawValue)
                        self.navigationItem.rightBarButtonItem?.isEnabled = self.itemAlbumList.unlock
                        self.itemAlbumList.unlock = true
                        self.btnStyUnlock.isHidden = true
                        self.btnStySelected.isEnabled = true
                        self.collectionAlbum.reloadData()
                    }
                }
            }))
            
            self.present(alertVC, animated: true, completion: nil)
            
        }else{
            print("Ya no tiene albumes para desbloquear")
            self.typeAlert = .callCenterUnblock
            self.infoMessage = ["\(infoAlbum.totalPurchase ?? 0)", "\(infoAlbum.totalUnlock ?? 0)"]
            self.performSegue(withIdentifier: "goAlbumToMessage", sender: nil)
        }
    }
    
    @objc func toggleSelectPhotos(sender: UIBarButtonItem){
        if modeShare {
            btnStyShare.isEnabled = false
            rightButton.title = "lbl_select_photo".getNameLabel()
            disableModeShare()
        } else {
            rightButton.title = "lbl_cancel".getNameLabel()
            modeShare = true
            showHideViewShare()
        }
    }
    
    func disableModeShare(){
        self.modeShare = false
        showHideViewShare()
        //Reinicialos el select
        selectedCells.removeAllObjects()
        selectedRows.removeAll()
    }
    
    
    func showHideViewShare(){
        self.collectionAlbum.reloadData()
        self.viewMenu.isHidden = !self.modeShare
        if self.modeShare {
//            self.title = "lbl_title_select_photos".getNameLabel().uppercased()//"titleSelectPhotos".localized().uppercased()
//            self.viewSharedBottomConstraint.constant = 0
//            self.viewMenu.isHidden = true
            self.viewMenuHeightContraint.constant = 50
        }else{
//            self.title = "\("lbl_title_albums".getNameLabel()) \(self.itemAlbumList.getNameByParkId.uppercased())"//String(format: "titlePhotosByAlbum".localized(), arguments: [self.itemAlbumList.getNameByParkId]).uppercased()
//            self.viewSharedBottomConstraint.constant = -self.viewShared.bounds.height
//            self.btnStyShare.isEnabled = false
//            self.viewMenu.isHidden = false
            self.viewMenuHeightContraint.constant = 0
        }
    }
    
    func downloadAndShareImages(completion:@escaping ([UIImage], [ItemPhoto]) -> ()){
        var listImages = [UIImage]()
        var listPhotosSelected = [ItemPhoto]()
        var count = 0
        for item in selectedRows {
            let photo = listPhotos[item].mink
            Tools.shared.getImageKingFisher(urlImage: photo!) { (imgDown) in
                listImages.append(imgDown)
                listPhotosSelected.append(self.listPhotos[item])
                count+=1
                if count == self.selectedRows.count {
                    completion(listImages, listPhotosSelected)
                }else{
                    print("Aun no termina el proceso")
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goPreview" {
            if let previewController = segue.destination as? PreviewViewController{
                previewController.listPhotos = self.listPhotos
                previewController.passedContentOffset = indexPathPhoto
                previewController.infoAlbum = self.infoAlbum
                previewController.albumUID = self.itemAlbumList.uid
            }
        }else if segue.identifier == "goAlbumToMessage" {
            if let messageController = segue.destination as? MessageViewController{
                messageController.typeAlertView = .callCenterUnblock
                messageController.arrayInfo = self.infoMessage
            }
        } else if segue.identifier == "showDownload" {
            if let downloadController = segue.destination as? DownloadViewController {
                downloadController.averageFileSize = fileSizeFirstPhoto
                downloadController.album = self.infoAlbum
                downloadController.albumDetail = self.itemAlbumList
                downloadController.delegate = self
            }
        }
    }
    
    func getFileSize(path: String){
        if let url = URL(string: path) {
            let downloader = ImageDownloader.default
            downloader.downloadImage(with: url, completionHandler:  { result in
                switch result {
                case .success(let value):
                    let fileSize = (Double(value.originalData.count) / 1024.0) / 1024.0
                    self.fileSizeFirstPhoto = fileSize
                case .failure(let error):
                    print("FileSize Error \(error)")
                }
            })
        }
    }
}

extension AlbumViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPhoto", for: indexPath) as! PhotoCollectionViewCell
        var isSelected = false
        if modeShare {
            if selectedRows.contains(indexPath.row){
                isSelected = true
            }
        }
        let urlImage = self.itemAlbumList.unlock ? listPhotos[indexPath.row].thumb : listPhotos[indexPath.row].mini
        cell.configureCell(urlPhoto: urlImage!, isSelected: isSelected, optSelected: self.modeShare)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if DeviceInfo.Orientation.isPortrait {
            return CGSize(width: width/4 - 1, height: width/4 - 1)
        } else {
            return CGSize(width: width/6 - 1, height: width/6 - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if itemAlbumList.unlock {
            if self.modeShare {
                //Verificamos si está seleccionado
                if selectedRows.contains(indexPath.row){
                    listPhotos[indexPath.row].isSelected = false
                    selectedRows.removeAll { $0 == indexPath.row }
                }else{
                    listPhotos[indexPath.row].isSelected = true
                    selectedRows.append(indexPath.row)
                }
                collectionAlbum.reloadItems(at: [indexPath])
                //Verificamos que tenga seleccionado fotos
//                if selectedRows.count > 0 {
//                    self.btnStyShare.isEnabled = true
//                }else{
//                    self.btnStyShare.isEnabled = false
//                }
                self.btnStyShare.isEnabled = !selectedRows.isEmpty
                
                if selectedRows.count >= listPhotos.count {
                    self.btnStyAlbum.setTitle("btn_unselect_all".getNameLabel(), for: .normal)
                } else {
                    self.btnStyAlbum.setTitle("lbl_select_photo_all".getNameLabel(), for: .normal)
                }
            }else{
                self.indexPathPhoto = indexPath
                self.performSegue(withIdentifier: "goPreview", sender: nil)
            }
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionAlbum.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

extension AlbumViewController: DownloadViewDelegate {
    func download() {
        self.shareImages()
    }
    
    func successSend() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
            self.performSegue(withIdentifier: "showSuccessSend", sender: nil)
        }
    }
}

extension AlbumViewController: MessageViewDelegate {
    func onClose() {
        self.navigationController?.popViewController(animated: true)
    }
}


struct DeviceInfo {
    struct Orientation {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}
