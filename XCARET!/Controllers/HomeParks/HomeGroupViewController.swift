//
//  HomeGroupViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 6/3/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import Lottie

class HomeGroupViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var listImages : [UIView] = [UIView]()
    var listParks : [ItemPark] = [ItemPark]()
    var currentItem : Int = 0
    var countImages : Int = 0
    let date = Date()
    let calendar = Calendar.current
    var year: Int = 0
    let viewAnimationLogoXH24: AnimationView = AnimationView()
    @IBOutlet weak var heightGradientConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionParks: UICollectionView!
    @IBOutlet weak var contentImageView: UIView!
    @IBOutlet weak var contentImageXafety: UIView!
    @IBOutlet weak var animationViewXafety: AnimationView!
    
    override func viewDidLoad() {
        
        let av = Animation.named("25_animado")
        self.viewAnimationLogoXH24.animation = av
        self.viewAnimationLogoXH24.contentMode = .scaleAspectFit
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.year = calendar.component(.year, from: self.date)
        super.viewDidLoad()
        self.title = "Home"
        self.heightGradientConstraint.constant = self.view.bounds.height / 2
        
        self.listParks = self.appDelegate.listAllParksEnabled
       
        if listParks.count > 0 {
            self.collectionParks.showsHorizontalScrollIndicator = false
            self.collectionParks.decelerationRate = UIScrollView.DecelerationRate.fast
            self.collectionParks.delegate = self
            self.collectionParks.dataSource = self
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goXafety))
            self.contentImageXafety.addGestureRecognizer(tapRecognizer)
            
            loadImages()
            loadLottieXafety()
        }
        
        //Tools.shared.ask4PermissionParkXcaret()
        appDelegate.requestReview()
        
        ArgAppUpdater.getSingleton().showUpdateConfirmInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let location = LocationSingleton.shared
        location.startLocation()
        self.animationViewXafety.play()
        collectionParks.reloadData()
    }
    
    func loadLottieXafety(){
        
        //Cargamos animacion
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.goXafety))
        self.animationViewXafety.addGestureRecognizer(gesture)
        let filename = "360Xafety"
        let av = Animation.named(filename)
        self.animationViewXafety.animation = av
        self.animationViewXafety.loopMode = .loop
        self.animationViewXafety.play()
    }
    
    func loadImages() {
        let folder = UIDevice().getFolder()
        let positionLogoX = self.view.frame.width / 2 - 110
        
        for item in listParks {
            countImages += 1
            let positionX = countImages == 1 ? 0 : self.view.frame.width
            let image = "\(folder)\(item.code ?? "")"
            let logoUrl = "Logos/logoHome\(item.code ?? "Group")"
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            let imageLogo = UIImageView(frame: CGRect(x: positionLogoX, y: 50, width: 220, height: 120))
            let viewImagePark = UIImageView(frame: CGRect(x: positionX, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            imageView.image = UIImage(named: image)
            imageLogo.image = UIImage(named: logoUrl)
            imageLogo.contentMode = .scaleAspectFit
            viewImagePark.addSubview(imageView)
            if item.code == "XH" && self.year == 2020 {
                viewAnimationLogoXH24.frame = CGRect(x: self.view.frame.width / 2 - 130, y: 50, width: 260, height: 160)
                viewImagePark.addSubview(viewAnimationLogoXH24)
            }else{
                viewImagePark.addSubview(imageLogo)
            }
            viewImagePark.tag = item.photoCode
           
            self.contentImageView.addSubview(viewImagePark)
            listImages.append(viewImagePark)
        }
    }
    
    func getInfoProductSelected(itemPark : ItemPark){
        appDelegate.itemParkSelected = itemPark
        //Analytics FB
        AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.ListMain.rawValue, title: itemPark.code.uppercased())
        /*SF*/
        let pageAttr = ["\(itemPark.code.uppercased())_HomeList": itemPark.code.uppercased()]
        (AppDelegate.getKruxTracker()).trackPageView("HomeGroup", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        switch itemPark.p_type {
        case "H": //Cuando es Hotel
            let HotelVC = AppStoryboard.Hotel.instance.instantiateViewController(withIdentifier: "HotelNC")
            HotelVC.modalPresentationStyle = .fullScreen
            self.present(HotelVC, animated: false)
        default: //Cuando es Parque
            LoadingView.shared.showActivityIndicator(uiView: self.view)
                FirebaseBR.shared.getInfoByParkSelected {
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    let parkVC = AppStoryboard.ParkXcaret.instance.instantiateViewController(withIdentifier: "XcaretTBC")
                    parkVC.modalPresentationStyle = .fullScreen
                    self.present(parkVC, animated: false)
                }
        }
    }
    
    @objc func goXafety(){
        
        let mainNC = AppStoryboard.Xafety.viewController(viewControllerClass: XafetyViewController.self)
        
//        mainNC.callingCode = "XafetyNC"
        self.navigationController?.pushViewController(mainNC, animated: true)
//        let mainNC = AppStoryboard.Xafety.instance.instantiateViewController(withIdentifier: "XafetyNC")
//        mainNC.modalPresentationStyle = .fullScreen
//        self.present(mainNC, animated: true, completion: nil)
    }
    
}

extension HomeGroupViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listParks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPark", for: indexPath) as! ItemParkCollectionViewCell
        cell.configureCell(itemPark: listParks[indexPath.row])
        print("index show \(indexPath.row) - Este es el parque \(listParks[indexPath.row].name!)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 40, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemPark = listParks[indexPath.row]
        if itemPark.code == "XS"{
            Vibration.heavy.vibrate()
        }
        self.getInfoProductSelected(itemPark: itemPark)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
        var visibleRect = CGRect()
        visibleRect.origin = collectionParks.contentOffset
        visibleRect.size = collectionParks.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionParks.indexPathForItem(at: visiblePoint) else { return }
        self.collectionParks.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        if currentItem != indexPath.row {
            var imageItem = UIView()
            var positionX : CGFloat = 0.0
//            print(" si indexpath.row \(indexPath.row) > currentItem \(self.currentItem)")
            
            if indexPath.row > currentItem {
                if !(self.currentItem + 1 == indexPath.row){
                    for index in (self.currentItem + 1)...(indexPath.row - 1) {
//                        print("index \(index)")
                        UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                            imageItem =  self.listImages[index]
                            imageItem.frame.origin.x = positionX
                        })
                    }
                }
                imageItem =  listImages[indexPath.row]
                positionX = 0
            }else{
                if !(indexPath.row + 1 == self.currentItem){
                    for index in (indexPath.row + 1)...(self.currentItem - 1) {
                        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                            imageItem =  self.listImages[index]
                            imageItem.frame.origin.x = self.view.frame.width
                        })
                    }
                }
                
                imageItem = listImages[currentItem]
                
                positionX = self.view.frame.width
            }

            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                imageItem.frame.origin.x = positionX
                self.currentItem = indexPath.row
            })
        }
        if currentItem == 1{
            viewAnimationLogoXH24.play()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndScrollingAnimation")
    }
}
