//
//  PreviewViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 4/11/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var buttonBackStyle: UIButton!
    @IBOutlet weak var buttonShareStyle: UIButton!
    @IBOutlet weak var viewMenuHeightConstraint: NSLayoutConstraint!
    var listPhotos : [ItemPhoto] = [ItemPhoto]()
    var photo : ItemPhoto = ItemPhoto()
    var passedContentOffset = IndexPath()
    var isFirstLoad : Bool = true
    var infoAlbum : ItemAlbum!
    var albumUID : String = ""
    @IBOutlet weak var collectionPreview: UICollectionView!
//    {
//        didSet{
//            self.collectionPreview.register(UINib.init(nibName: "ImagePreviewFullViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor=UIColor.black
        //self.setStatusBarStyle(.lightContent)
        /*Configuramos botones*/
        self.buttonBackStyle.setTitle("btn_back".getNameLabel()/*"lblBack".localized()*/, for: .normal)
        self.buttonShareStyle.setTitle("btn_tab_share".getNameLabel()/*"bntShare".localized()*/, for: .normal)
        self.viewMenuHeightConstraint.constant = UIDevice().getHeightViewCode()
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "Icons/photo/ic_regresar"), style: .plain, target: self, action: #selector(goBack))
        let rightButton = UIBarButtonItem(image: UIImage(named: "Icons/photo/ic_share_ios"), style: .plain, target: self, action: #selector(share))
        leftButton.tintColor = UIColor.white
        rightButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        
        //Configuramos layout
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumInteritemSpacing=0
//        layout.minimumLineSpacing=0
//        layout.scrollDirection = .horizontal
        
        if listPhotos.count > 0 {
            let floawLayout = UPCarouselFlowLayout()
            floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            floawLayout.scrollDirection = .horizontal
            floawLayout.sideItemScale = 1.0
            floawLayout.sideItemAlpha = 1.0
            floawLayout.accessibilityElementsHidden = true
            floawLayout.spacingMode = .fixed(spacing: 0.0)
            collectionPreview.collectionViewLayout = floawLayout
            
            
            //collectionPreview.isPagingEnabled = true
            collectionPreview.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "Cell")
            collectionPreview.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
            collectionPreview.layoutIfNeeded()
            collectionPreview.delegate = self
            collectionPreview.dataSource = self
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.setIndexPosition), name: UIDevice.orientationDidChangeNotification, object: nil)
        }
        
    }
    
    @objc public func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc public func share() {
        compartir()
    }
    
    @objc public func setIndexPosition(){
        let index = passedContentOffset
        self.collectionPreview.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        self.collectionPreview.layoutIfNeeded()
    }
        
        func setPositionActivity(index : Int){
            
            if listPhotos.count > index{
                let indexP = IndexPath(item: index, section: 0)
                DispatchQueue.main.async {
//                    self.collectionPreview.reloadData()
//                    self.collectionPreview.layoutIfNeeded()
//                    self.collectionPreview.selectItem(at: indexP, animated: true, scrollPosition: .centeredHorizontally)
                }
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if (scrollView == collectionPreview) {
            let layout = self.collectionPreview.collectionViewLayout as! UPCarouselFlowLayout
            let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
            let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
                photoPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            }
            
        }
        
        fileprivate var photoPage: Int = 0 {
            didSet {
                print("page at centre = \(photoPage)")
                setPositionActivity(index: photoPage)
            }
        }
        
        fileprivate var pageSize: CGSize {
            let layout = self.collectionPreview.collectionViewLayout as! UPCarouselFlowLayout
            var pageSize = layout.itemSize
            if layout.scrollDirection == .horizontal {
                pageSize.width += layout.minimumLineSpacing
            } else {
                pageSize.height += layout.minimumLineSpacing
            }
            return pageSize
        }
    

    override func viewDidAppear(_ animated: Bool) {
        let indexP = passedContentOffset
        UIView.animate(withDuration: 10, animations: { [weak self] in
            let index = IndexPath.init(item: indexP.row, section: 0)
            self?.collectionPreview.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self?.collectionPreview.layoutIfNeeded()
        })
    }
        
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bntShare(_ sender: UIButton) {
        
//        UIView.animate(withDuration: 10, animations: { [weak self] in
//            let index = IndexPath.init(item: 13, section: 0)
//            self?.collectionPreview.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//            self?.collectionPreview.layoutIfNeeded()
//        })
//        //compartir()
    }
    
    func compartir(){
        LoadingView.shared.showActivityIndicator(uiView: self.view, type: .loadPhoto)
        downloadAndShareImages { (listImg, listPhotosSelected) in
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            if listImg.count > 0 {
                let activityViewController = UIActivityViewController(activityItems: listImg , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.completionWithItemsHandler = { activity, success, items, error in
                    if success{
                        FirebaseDB.shared.saveInteractionPhoto(code: self.infoAlbum.code , albumUID: self.albumUID, listPhotos: listPhotosSelected, completion: { (success) in
                            if success{
                                AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Photo.rawValue, title: TagsPhoto.shareOnlyPhoto.rawValue)
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
    
    func downloadAndShareImages(completion:@escaping ([UIImage], [ItemPhoto]) -> ()){
        var listImages = [UIImage]()
        var listPhotosSelected = [ItemPhoto]()
        var visibleRect = CGRect()
        visibleRect.origin = collectionPreview.contentOffset
        visibleRect.size = collectionPreview.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionPreview.indexPathForItem(at: visiblePoint) else { return }
        self.passedContentOffset = indexPath
        let item: String = listPhotos[indexPath.row].mink!
        if !item.isEmpty{
            Tools.shared.getImageKingFisher(urlImage: item) { (imgDown) in
                listImages.append(imgDown)
                listPhotosSelected.append(self.listPhotos[indexPath.row])
                completion(listImages, listPhotosSelected)
            }
        }else{
            completion(listImages, listPhotosSelected)
        }
        
    }
    
}

extension PreviewViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
        let urlImage = listPhotos[indexPath.row].mink
        let url = URL(string: urlImage!)
        self.buttonShareStyle.isEnabled = false
        cell.imgView.kf.indicatorType = .activity
        cell.imgView.kf.setImage(
            with: url,
            placeholder : UIImage(named: "Icons/photo/ic_defaultLarge"),
            completionHandler : { result in
                switch result{
                case .success( _):
                    self.buttonShareStyle.isEnabled = true
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}


//Manejo de la imagen
class ImagePreviewFullViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var scrollImg: UIScrollView!
    var imgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        scrollImg = UIScrollView()
        scrollImg.delegate = self
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()

        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 4.0

        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollImg.addGestureRecognizer(doubleTapGest)

        self.addSubview(scrollImg)

        imgView = UIImageView()
        imgView.image = UIImage(named: "Parks/XH/Activities/xh_adrenalina")
        scrollImg.addSubview(imgView!)
        imgView.contentMode = .scaleAspectFit
    }
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollImg.zoomScale == 1 {
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)
        }
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgView.frame.size.height / scale
        zoomRect.size.width  = imgView.frame.size.width  / scale
        let newCenter = imgView.convert(center, from: scrollImg)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollImg.frame = self.bounds
        imgView.frame = self.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        scrollImg.setZoomScale(1, animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
