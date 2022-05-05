//
//  ItemScheduleAdmissionTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 26/07/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class ItemScheduleAdmissionTableViewCell: UITableViewCell {
    var listScheduleA : [ItemScheduleDest] = [ItemScheduleDest]()
    var listScheduleB : [ItemScheduleDest] = [ItemScheduleDest]()
    var destinationA : ItemDestination = ItemDestination()
    var destinationB : ItemDestination = ItemDestination()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageViewMapA: UIImageView!
    @IBOutlet weak var lblDestinationA: UILabel!
    @IBOutlet weak var btnDestinationA: UIButton!
    @IBOutlet weak var collectionViewDestinationA: UICollectionView! {
        didSet{
            
            self.collectionViewDestinationA.register(UINib.init(nibName: "ItemScheduleDestinationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellSchedule")
        }
    }
    @IBOutlet weak var collectionAHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var imageViewMapB: UIImageView!
    @IBOutlet weak var lblDestinatioB: UILabel!
    @IBOutlet weak var btnDestinationB: UIButton!
    @IBOutlet weak var collectionViewDestinationB: UICollectionView! {
        didSet{
            self.collectionViewDestinationB.register(UINib.init(nibName: "ItemScheduleDestinationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellSchedule")
        }
    }
    @IBOutlet weak var collectionBHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblAddressA: UILabel!
    
    @IBOutlet weak var lblAddressB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionViewDestinationA.collectionViewLayout = setFlowLayout()
        self.collectionViewDestinationA.showsHorizontalScrollIndicator = false
        
        self.collectionViewDestinationB.collectionViewLayout = setFlowLayout()
        self.collectionViewDestinationB.showsHorizontalScrollIndicator = false
    }
    
    func setFlowLayout()-> UICollectionViewFlowLayout{
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        return flowLayout
    }
    
    func setInfoView(listAdmission: [ItemAdmission]){
        lblTitle.text = "fe_departure_times".getNameLabel()
        if listAdmission.count > 0 {
            let destinations = listAdmission[0].getDestiations
            if destinations.count > 0 {
                destinationA = destinations[0]
                destinationB = destinations[1]
                
                //DestinationA
                listScheduleA = destinations[0].getSchedules
                lblDestinationA.text = destinationA.name
                lblAddressA.text = destinationA.getDetail.address
                imageViewMapA.image = UIImage(named: "Parks/FE/Destination/\(destinationA.name_image ?? "")")
                if listScheduleA.count > 0 {
                    self.collectionViewDestinationA.dataSource = self
                    self.collectionViewDestinationA.delegate = self
                }
                
                //DestinationB
                listScheduleB = destinations[1].getSchedules
                lblDestinatioB.text = destinationB.name
                lblAddressB.text = destinationB.getDetail.address
                imageViewMapB.image = UIImage(named: "Parks/FE/Destination/\(destinationB.name_image ?? "")")
                if listScheduleB.count > 0 {
                    self.collectionViewDestinationB.dataSource = self
                    self.collectionViewDestinationB.delegate = self
                }
            }
        }
        
        
            self.collectionAHeight.constant = self.collectionViewDestinationA.collectionViewLayout.collectionViewContentSize.height
            self.collectionBHeight.constant = self.collectionViewDestinationB.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewDestinationA.reloadData()
            self.collectionViewDestinationB.reloadData()
        
        let tapRecognizerMapA = UITapGestureRecognizer(target: self, action: #selector(goAddressA))
        self.imageViewMapA.addGestureRecognizer(tapRecognizerMapA)
        
        let tapRecognizerMapB = UITapGestureRecognizer(target: self, action: #selector(goAddressB))
        self.imageViewMapB.addGestureRecognizer(tapRecognizerMapB)
        
    }
    
    @IBAction func btnSendAddressA(_ sender: UIButton) {
        self.sendAddres(lat: destinationA.latitude, lon: destinationA.longitude)
    }
    
    
    @IBAction func btnSendAddressB(_ sender: UIButton) {
        self.sendAddres(lat: destinationB.latitude, lon: destinationB.longitude)
    }
    
    @objc func goAddressA(){
        self.sendAddres(lat: destinationA.latitude, lon: destinationA.longitude)
    }
    
    @objc func goAddressB(){
        self.sendAddres(lat: destinationB.latitude, lon: destinationB.longitude)
    }
    
    private func sendAddres(lat: Double, lon: Double){
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?daddr=\(lat),\(lon)&directionsmode=driving")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://")
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps/dir/?daddr=\(lat),\(lon)&directionsmode=driving")!, options: [:], completionHandler: nil)
        }
    }
    
}

extension ItemScheduleAdmissionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewDestinationA{
            return self.listScheduleA.count
        }else{
            return self.listScheduleB.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewDestinationA{
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "cellSchedule", for: indexPath as IndexPath) as! ItemScheduleDestinationCollectionViewCell
            cellA.configureCell(schedule: listScheduleA[indexPath.row].schedule)
            return cellA
        }else{
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "cellSchedule", for: indexPath as IndexPath) as! ItemScheduleDestinationCollectionViewCell
            cellB.configureCell(schedule: listScheduleB[indexPath.row].schedule)
            return cellB
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewDestinationA{
            let width = collectionViewDestinationA.bounds.width
            return CGSize(width: width/4, height: 40)
        }else{
            let width = collectionViewDestinationB.bounds.width
            return CGSize(width: width/4, height: 40)
        }
    }
    
}
