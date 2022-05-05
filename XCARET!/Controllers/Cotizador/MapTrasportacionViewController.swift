//
//  MapTrasportacionViewController.swift
//  XCARET!
//
//  Created by Yeik on 07/04/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import GoogleMaps

class MapTrasportacionViewController: UIViewController {
    
    weak var delegateLocation: ManageLocation?

    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var viewMapConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewContentlLocations: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var viewContentPickUps: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    let buttonBar = UIView()
    var itemCarShoop = ItemCarShoop()
    var listItemsLocations = [ItemLocations]()
    var listItemsLocationsCount = [ItemLocations]()
    var listItemsLocationsCollection = [ItemLocations]()
    @IBOutlet weak var topMapConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentHorarios: UIView!
    var itemsLocations = [ItemLocations]()
    var itemLocation = ItemLocation()
    var itemsCountHorarios = [ItemLocations]()
    
    @IBOutlet weak var marcoItemLocation: UIView!
    @IBOutlet weak var btnAceptar: UIButton!
    @IBOutlet weak var noHotelLbl: UILabel!
    @IBOutlet weak var hotelLbl: UILabel!
    @IBOutlet weak var pickupLbl: UILabel!
    
    
    @IBOutlet weak var ItemsLocationsPickupCollection: UICollectionView!
    @IBOutlet weak var ItemsHorariosLocationPickupCollection: UICollectionView!
    @IBOutlet weak var itemsLocationsCollections: UICollectionView! {
        didSet{
            self.itemsLocationsCollections.register(UINib.init(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemLocation")
            self.itemsLocationsCollections.register(UINib.init(nibName: "SinDatosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sinDatos")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAceptar.isEnabled = false
        btnAceptar.alpha = 0.5
        topMapConstraint.constant = 15
        contentHorarios.isHidden = true
        
        titleLbl.textColor = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.0)
        titleLbl.text = "lbl_pickup_dialog_title".getNameLabel()
        btnAceptar.setTitle("lbl_pickup_dialog_accept".getNameLabel(), for: .normal)
        noHotelLbl.text = "lbl_pickup_dialog_no_hotel".getNameLabel()
        hotelLbl.text = "lbl_pickup_dialog_hotel".getNameLabel()
        pickupLbl.text = "lbl_pickup_dialog_pickup".getNameLabel()
        locationSwitch.addTarget(self, action: #selector(locationSwitchChanged), for: UIControl.Event.valueChanged)
        
        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 60.0, height: 60)
        floawLayout.scrollDirection = .vertical
        floawLayout.sideItemScale = 0.98
        floawLayout.sideItemAlpha = 0.4
        floawLayout.accessibilityElementsHidden = true
        floawLayout.spacingMode = .fixed(spacing: 0.0)
        itemsLocationsCollections.collectionViewLayout = floawLayout
        
        for itemLoc in itemsLocations {
            if listItemsLocationsCollection.isEmpty {
                listItemsLocationsCollection.append(itemLoc)
            }else{
                let itemIn = listItemsLocationsCollection.filter({ $0.id ==  itemLoc.id})
                if itemIn.count == 0 {
                    listItemsLocationsCollection.append(itemLoc)
                }
            }
        }
        listItemsLocationsCollection = listItemsLocationsCollection.filter({ $0.name != "Otro"})
        listItemsLocationsCollection = listItemsLocationsCollection.sorted(by: { $0.id < $1.id })
        
        let aux = itemsLocations
        print(aux)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.itemsLocationsCollections.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            print("page at centre = \(currentPage)")
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.itemsLocationsCollections.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    func configSelect(itemSelect : ItemLocations, index : Int = 0){
        
        itemsCountHorarios = itemsLocations.filter({ $0.id == itemSelect.id })
//        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            if self.itemsCountHorarios.count > 1 {
                self.itemsCountHorarios = self.itemsCountHorarios.sorted(by: { $0.date < $1.date })
                self.ItemsHorariosLocationPickupCollection.reloadData()
                let indexHorariosLocationPickup = IndexPath(item: 0, section: 0)
                DispatchQueue.main.async {
                    self.topMapConstraint.constant = 75
                    self.contentHorarios.isHidden = false
                    self.collectionView(self.ItemsHorariosLocationPickupCollection, didSelectItemAt: indexHorariosLocationPickup)
                }
                
            }else{
                self.topMapConstraint.constant = 15
                self.contentHorarios.isHidden = true
                self.listItemsLocationsCount = self.itemsLocations.filter({ $0.id == itemSelect.id })
                self.itemsLocationsCollections.reloadData()
            }
//        })
    }
    
    
//    func configTable(locations : [ItemLocations]){
//        listItemsLocations = locations
//        let locationSorted = listItemsLocations.sorted(by: { $0.id < $1.id })
//        listItemsLocationsCount = locations.filter({ $0.name == locationSorted.first?.name})
//        itemsLocationsCollections.reloadData()
//        let indexPath = IndexPath(item: 0, section: 0)
//        DispatchQueue.main.async {
//            self.itemsLocationsCollections.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
//        }
//        LoadingView.shared.hideActivityIndicator(uiView: self.view)
//    }
    
    @objc func locationSwitchChanged(mySwitch: UISwitch) {
        viewMap.clear()
        let camera = GMSCameraPosition.camera(withLatitude: 20.8417587, longitude: -86.8941541, zoom: 7.5)
        viewMap.camera = camera
        let value = mySwitch.isOn
        if value {
            viewContentlLocations.isUserInteractionEnabled = false
            viewContentlLocations.alpha = 0.5
            contentHorarios.isUserInteractionEnabled = false
            contentHorarios.alpha = 0.5
            buttonBar.alpha = 0.5
            let aux = itemsLocations
            listItemsLocationsCount = itemsLocations.filter({ $0.name == "Otro" })
            itemsLocationsCollections.reloadData()
        }else{
            viewContentlLocations.isUserInteractionEnabled = true
            viewContentlLocations.alpha = 1
            contentHorarios.isUserInteractionEnabled = true
            contentHorarios.alpha = 1
            buttonBar.alpha = 1
            let indexPath = IndexPath(item: 0 , section: 0)
            DispatchQueue.main.async {
                self.collectionView(self.ItemsLocationsPickupCollection, didSelectItemAt: indexPath)
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let camera = GMSCameraPosition.camera(withLatitude: 20.8417587, longitude: -86.8941541, zoom: 7.5)
        viewMap.camera = camera
        
        let indexPath = IndexPath(item: 0 , section: 0)
        DispatchQueue.main.async {
            self.ItemsLocationsPickupCollection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            self.collectionView(self.ItemsLocationsPickupCollection, didSelectItemAt: indexPath)
        }

    }
    
    @IBAction func aceptarBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegateLocation?.itemLocation(itemLocation: itemLocation)
    }
}

extension MapTrasportacionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 1
        if collectionView == itemsLocationsCollections {
            listItemsLocationsCount.first?.itemLocation = listItemsLocationsCount.first?.itemLocation.filter({ $0.location.latitude != 0 && $0.location.longitude != 0 }) ?? [ItemLocation]()
            if listItemsLocationsCount.first?.itemLocation.count != 0 || listItemsLocationsCount.first?.itemLocation.count != nil {
                count = listItemsLocationsCount.first?.itemLocation.count ?? 1
            }
        }else if collectionView == ItemsLocationsPickupCollection {
            count = listItemsLocationsCollection.count
        }else if collectionView == ItemsHorariosLocationPickupCollection{
            count = itemsCountHorarios.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == itemsLocationsCollections {
            if indexPath.row == 0 && (listItemsLocationsCount.first?.itemLocation.count == 0 || listItemsLocationsCount.first?.itemLocation.count == nil) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sinDatos", for: indexPath) as! SinDatosCollectionViewCell
                marcoItemLocation.isHidden = true
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemLocation", for: indexPath) as! LocationCollectionViewCell
                marcoItemLocation.isHidden = false
                cell.configLabelLocation(itemLocation: listItemsLocationsCount.first?.itemLocation[indexPath.row] ?? ItemLocation())
                return cell
            }
        }else if collectionView == ItemsLocationsPickupCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationPickup", for: indexPath) as! LocationPickupCollectionViewCell
            cell.configItem(item : listItemsLocationsCollection[indexPath.row])
            return cell
        }else if collectionView == ItemsHorariosLocationPickupCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorariosLocationPickup", for: indexPath) as! HorariosLocationPickupCollectionViewCell
            cell.configHorario(item: itemsCountHorarios[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sinDatos", for: indexPath) as! SinDatosCollectionViewCell
            marcoItemLocation.isHidden = true
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == itemsLocationsCollections {
            let loc = listItemsLocationsCount.first?.itemLocation[indexPath.row]
            itemLocation = loc!
            btnAceptar.isEnabled = true
            btnAceptar.alpha = 1
            if loc?.location.longitude != 0 && loc?.location.latitude != 0 {
                let long = loc?.location.longitude
                let lat = loc?.location.latitude
                viewMap.clear()
                viewMap.camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 15.0)
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat!, longitude: long!))
                marker.title = loc?.name
                marker.map = viewMap
            }
            DispatchQueue.main.async {
                self.itemsLocationsCollections.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            }
        }else if collectionView == ItemsLocationsPickupCollection {
            let itemHorarios = listItemsLocationsCollection[indexPath.row]
            let indexPath = IndexPath(item: indexPath.row , section: 0)
            DispatchQueue.main.async {
                self.ItemsLocationsPickupCollection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
            configSelect(itemSelect: itemHorarios, index: indexPath.row)
        }else if collectionView == ItemsHorariosLocationPickupCollection {
            let itemHorarios = itemsCountHorarios[indexPath.row]
            listItemsLocationsCount = itemsCountHorarios.filter({ $0.id == itemHorarios.id && $0.date == itemHorarios.date })
            let indexHorariosLocationPickup = IndexPath(item: indexPath.row, section: 0)
            
            itemsLocationsCollections.reloadData()
            DispatchQueue.main.async {
//                self.ItemsHorariosLocationPickupCollection.reloadData()
                self.ItemsHorariosLocationPickupCollection.selectItem(at: indexHorariosLocationPickup, animated: true, scrollPosition: .centeredHorizontally)
//                self.collectionView(self.ItemsHorariosLocationPickupCollection, didSelectItemAt: indexHorariosLocationPickup)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ItemsLocationsPickupCollection {
            return CGSize(width: 150.0, height: 35.0)
        }else if collectionView == ItemsHorariosLocationPickupCollection{
            return CGSize(width: 100.0, height: 35.0)
        }else{
            return CGSize(width: viewContentPickUps.bounds.size.width, height: 60.0)
        }
    }
    
}

