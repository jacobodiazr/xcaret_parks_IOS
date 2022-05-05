//
//  ItemDetailParkTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 11/27/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class ItemDetailParkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSlogan: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTitleAwards: UILabel!
    @IBOutlet weak var heightLblTitleAwards: NSLayoutConstraint!
    @IBOutlet weak var TopLblTitleAwards: NSLayoutConstraint!
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var viewSegmentControl: UIView!
    @IBOutlet weak var segmentRecomendations: UISegmentedControl!
    @IBOutlet weak var lblDescriptionSegment: UILabel!
    @IBOutlet weak var lblSchedulePark: UILabel!
    var colorBack: UIColor = UIColor()
    
    var pressInclude: Bool = true
    var segmentSelected : Bool = true
    
    let buttonBar = UIView()
    weak var detailParkVC : DetailParkViewController?
    var itemPark: ItemPark = ItemPark()
    @IBOutlet weak var btnCallCenter: UIButton!
    @IBOutlet weak var topBtnCallCenter: NSLayoutConstraint!
    @IBOutlet weak var collectionAwards: UICollectionView!
    @IBOutlet weak var heighCollectionAwards: NSLayoutConstraint!
    //@IBOutlet weak var topViewAddressConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewContentDetail: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.colorBack = appDelegate.itemParkSelected.code == "XF" ? Constants.COLORS.GENERAL.customDarkMode : .white
        if appDelegate.itemParkSelected.code == "XF" {
            lblTitle.textColor = Constants.COLORS.GENERAL.customRedDarkModeXF
            lblSlogan.textColor = Constants.COLORS.GENERAL.customRedDarkModeXF
            lblTitleAwards.textColor = Constants.COLORS.GENERAL.customRedDarkModeXF
            lblDescription.textColor = .white
            lblAddress.textColor = .white
            lblDescriptionSegment.textColor = .white
        }
        if #available(iOS 13, *) {
            segmentRecomendations.setOldLayout(tintColor: colorBack)
        }else{
            self.segmentRecomendations.backgroundColor = self.colorBack
            self.segmentRecomendations.tintColor = self.colorBack
        }
        viewContentDetail.backgroundColor = colorBack
        viewSegmentControl.backgroundColor = colorBack
        collectionAwards.backgroundColor = colorBack
        
        
        
        self.segmentRecomendations.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: Constants.COLORS.ITEMS_CELLS.tabInactive], for: .normal)
        self.segmentRecomendations.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: Constants.COLORS.ITEMS_CELLS.tabActive], for: .selected)
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = Constants.COLORS.ITEMS_CELLS.tabActiveOutline
        viewSegmentControl.addSubview(buttonBar)
        
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: segmentRecomendations.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentRecomendations.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentRecomendations.widthAnchor, multiplier: 1 / CGFloat(segmentRecomendations.numberOfSegments)).isActive = true
        segmentRecomendations.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
        imgMap.isUserInteractionEnabled = true
        imgMap.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goGoogleMaps)))
        imgMap.image = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/howarrive") //viewMapContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goGoogleMaps)))
        
        //CollectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        self.collectionAwards.collectionViewLayout = flowLayout
        self.collectionAwards.showsHorizontalScrollIndicator = false
        self.collectionAwards.delegate = self
        self.collectionAwards.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setInformation(){
        segmentRecomendations.setTitle("lbl_include_2".getNameLabel()/*"lblInclude2".localized()*/, forSegmentAt: 0)
        segmentRecomendations.setTitle("lbl_recommendations".getNameLabel()/*"lblRecommendations".localized()*/, forSegmentAt: 1)
        lblTitleAwards.text = "lbl_title_awards".getNameLabel()//"lblTitleAwards".localized()
        btnCallCenter.setTitle("lbl_call_center".getNameLabel().uppercased(), for: .normal)//("lblCallCenter".localized().uppercased(), for: .normal)
        lblTitle.text = itemPark.name
        lblSlogan.text = itemPark.detail.slogan
        lblDescription.text = itemPark.detail.description
        lblAddress.text = itemPark.detail.address
        lblSchedulePark.text = itemPark.detail.p_schelude
        
        if self.segmentSelected{
            lblDescriptionSegment.text = itemPark.detail.include
        }else{
            lblDescriptionSegment.text = itemPark.detail.recomendations
        }
        
        lblDescriptionSegment.numberOfLines = 0
        lblDescriptionSegment.sizeToFit()
        
        if itemPark.listAwards.count > 0 {
            self.collectionAwards.reloadData()
        }else{
            self.collectionAwards.isHidden = true
            self.lblTitleAwards.isHidden = true
            self.heightLblTitleAwards.constant = 0
            self.heighCollectionAwards.constant = 0
            self.topBtnCallCenter.constant = 0
            self.TopLblTitleAwards.constant = 15
//            self.topViewAddressConstraint.constant = -180
        }
        
    }
    
    @objc func goGoogleMaps(){
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.ParkDetail.rawValue, title: TagsID.showGoogleMaps.rawValue)
        /*SF*/
        let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ParkMap": true]
        (AppDelegate.getKruxTracker()).trackPageView("ParkDetail", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        let lat = "\(appDelegate.itemMapSelected.latitude!)"
        let lon = "\(appDelegate.itemMapSelected.longitude!)"
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
             UIApplication.shared.open(URL(string:"comgooglemaps://?daddr=\(lat),\(lon)&directionsmode=driving")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://")
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps/dir/?daddr=\(lat),\(lon)&directionsmode=driving")!, options: [:], completionHandler: nil)
        }
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.segmentRecomendations.frame.width / CGFloat(self.segmentRecomendations.numberOfSegments)) * CGFloat(self.segmentRecomendations.selectedSegmentIndex)
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            segmentSelected = true
        default:
            segmentSelected = false
        }
        
        self.detailParkVC!.updateTable(segmentSelected: self.segmentSelected)
    }
    
    @IBAction func btnCallCenter(_ sender: Any) {
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.ParkDetail.rawValue, title: TagsID.callNow.rawValue)
        /*SF*/
        let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ParkCall": true]
        (AppDelegate.getKruxTracker()).trackPageView("ParkDetail", pageAttributes:pageAttr, userAttributes:nil)
        /**/
    }
}


extension ItemDetailParkTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemPark.listAwards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAward", for: indexPath) as! ItemAwardCollectionViewCell
        cell.configCell(itemAward: itemPark.listAwards[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 140)
    }
}

extension UISegmentedControl
{
    func setOldLayout(tintColor: UIColor)
    {
        let bg = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
        let devider = UIImage(color: tintColor, size: CGSize(width: 1, height: 32))

        //set background images
        self.setBackgroundImage(bg, for: .normal, barMetrics: .default)
        self.setBackgroundImage(devider, for: .selected, barMetrics: .default)

        //set divider color
        self.setDividerImage(devider, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        //set border
        self.layer.borderWidth = 0
        self.layer.borderColor = tintColor.cgColor

        //set label color
        self.setTitleTextAttributes([.foregroundColor: tintColor], for: .normal)
        self.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}
extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.init(data: image.pngData()!)!
    }
}
