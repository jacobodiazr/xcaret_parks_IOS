//
//  HotelMainViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 6/24/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class HotelMainViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private var tableHeaderViewHeight: CGFloat = 0
    private let tableHeaderViewCutaway: CGFloat = 0
    var headerView: HotelMainHeaderView!
    var listInfoHotel : [ItemInfoHotel]! = [ItemInfoHotel]()
    let transition = CircularTransition()
    let buttonBack = UIButton()
    
    @IBOutlet weak var tblHotel: UITableView! {
        didSet{
            tblHotel.register(UINib(nibName: "ItemInfoHotelTableViewCell", bundle: nil), forCellReuseIdentifier: "cellInfo")
            tblHotel.register(UINib(nibName: "ItemStackTableViewCell", bundle: nil), forCellReuseIdentifier: "cellStack")
            tblHotel.register(UINib(nibName: "Item360TableViewCell", bundle: nil), forCellReuseIdentifier: "cell360")
            tblHotel.register(UINib(nibName: "ItemRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "cellRoom")
            tblHotel.register(UINib(nibName: "ItemAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "cellAddress")
            tblHotel.register(UINib(nibName: "ItemButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSeeAll")
            tblHotel.register(UINib(nibName: "ItemGoHotelTableViewCell", bundle: nil), forCellReuseIdentifier: "cellGoHotel")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBack.setImage(UIImage(named:"Icons/ico_back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonBack.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        buttonBack.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -10)
       
        buttonBack.addTarget(self, action: #selector(self.unloadPark), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonBack)
        
        self.tableHeaderViewHeight = (self.view.frame.height * 0.70)
        self.tblHotel.rowHeight = 500
        self.tblHotel.estimatedRowHeight = 500
        self.tblHotel.showsVerticalScrollIndicator = false
        self.tblHotel.delegate = self
        self.tblHotel.dataSource = self
        self.configHeaderTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        buttonBack.setTitle("lbl_parks".getNameLabel(), for: .normal)//("lblParks".localized(), for: .normal)
        buttonBack.sizeToFit()
        
        FirebaseBR.shared.getInfoHotel { (listInfo) in
            self.listInfoHotel = listInfo
            self.tblHotel.reloadData()
        }
    }
    
    func configHeaderTableView(){
        headerView = (tblHotel.tableHeaderView as! HotelMainHeaderView)
        tblHotel.tableHeaderView = nil
        tblHotel.addSubview(headerView)
        tblHotel.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tblHotel.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
        updateHeaderView()
    }
    
    func updateHeaderView(){
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: self.view.frame.width, height: tableHeaderViewHeight)
        
        if tblHotel.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tblHotel.contentOffset.y
            headerRect.size.height = -tblHotel.contentOffset.y + tableHeaderViewCutaway/2
            headerView.frame = headerRect
        }else{
            tblHotel.sectionHeaderHeight = headerRect.size.height
        }
    }
    
    @objc func unloadPark(){
        self.dismiss(animated: true, completion: nil)
        FirebaseBR.shared.getResetInformation()
    }
    
    func goGoogleMaps(){
        let lat = "20.5851884"
        let lon = "-87.11282"
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?daddr=\(lat),\(lon)&directionsmode=driving")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://")
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps/dir/?daddr=\(lat),\(lon)&directionsmode=driving")!, options: [:], completionHandler: nil)
        }
    }
}

extension HotelMainViewController : UITableViewDelegate, UITableViewDataSource, ItemButtonTableViewCellDelegate {
    func getAction(_sender: ItemButtonTableViewCell) {
        self.performSegue(withIdentifier: "goCallCenterHotel", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listInfoHotel.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell : ItemInfoHotelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! ItemInfoHotelTableViewCell
            cell.configureCell(itemHotel: appDelegate.itemParkSelected)
            return cell
        }else {
            let info = listInfoHotel[indexPath.row - 1]
            switch info.typeCellHotel {
            case .cellStack , .cellAFI :
                let cell : ItemStackTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellStack", for: indexPath) as! ItemStackTableViewCell
                let info = listInfoHotel[indexPath.row - 1]
                cell.configTableCell(itemInfo: info)
                return cell
            case .cellGoHotel :
                let cell : ItemGoHotelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellGoHotel", for: indexPath) as! ItemGoHotelTableViewCell
                return cell
            case .cell360:
                let cell : Item360TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell360", for: indexPath) as! Item360TableViewCell
                cell.configTableCell(itemInfo: info)
                return cell
            case .cellRooms:
                let cell : ItemRoomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellRoom", for: indexPath) as! ItemRoomTableViewCell
                cell.configTableCell(itemInfo: info)
                return cell
            case .cellAddress:
                let cell : ItemAddressTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellAddress", for: indexPath) as! ItemAddressTableViewCell
                cell.configTableCell(itemInfo: info)
                return cell
            case .cellCallCenter:
                let cell : ItemButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellSeeAll", for: indexPath) as! ItemButtonTableViewCell
                cell.setCell(code: "HOTEL")
                cell.delegate = self
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let info = listInfoHotel[indexPath.row - 1]
            if info.typeCellHotel == TypeCellHotel.cell360 {
                self.performSegue(withIdentifier: "goView360", sender: nil)
            }else if info.typeCellHotel == TypeCellHotel.cellAddress {
                self.goGoogleMaps()
            }else if info.typeCellHotel == TypeCellHotel.cellGoHotel {
                let customUrl = "AppHotelOpen://"
                if let url = URL(string: customUrl){
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url)
                    }else{
                        let url = URL(string: "itms-apps://itunes.apple.com/app/1474819420")!
                        if #available(iOS 10.0, *){
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }else{
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 0 {
            let info = listInfoHotel[indexPath.row - 1]
            switch info.typeCellHotel {
            case .cellCallCenter:
                return info.heighView.height
            default:
                return UITableView.automaticDimension
            }
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}
