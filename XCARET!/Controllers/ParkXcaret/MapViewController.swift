//
//  MapViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 11/20/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import GoogleMaps
import PMAlertController

class MapViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locationManager: CLLocationManager! = CLLocationManager()
    var mapInfo : ItemMapInfo = ItemMapInfo()
    var mapView: GMSMapView!
    var btnFilter : UIButton!
    var hideTabbar : Bool = false
    var listAllActivities = [ItemActivity]()
    var listAllServices = [ItemServicesLocation]()
    var listActivitiesFilter = [ItemActivity]()
    var listServicesFilter = [ItemServicesLocation]()
    var listMarkersAct = [GMSMarker]()
    var listMarkersServ = [GMSMarker]()
    var sideMenu : SideMapView!
    var typeCollection : TypeEntity!
    var typeCallController : String!
    var activitySelected = ItemActivity()
    var coords: CLLocationCoordinate2D!
    var intoThePark = false
    var isInit: Bool! = true
    var polylineMap : GMSPolyline!
    var markerSelectedInMap : GMSMarker?
    var isFirst = AppUserDefaults.value(forKey: .FirstInteracionFilter, fallBackValue: true)
    let heightColServices : CGFloat = 100.0
    let heightColActivities : CGFloat = 130.0
    
    var animationPolyline = GMSPolyline()
    var animationPath = GMSMutablePath()
    var path = GMSPath()
    var i: UInt = 0
    var timer: Timer!
    var stopTimer: Bool = true
    var searchBar : UISearchBar?
    
    /*var GeoAngle = 0.0
    var currentMarkerGPS = GMSMarker()*/
    
    var collectionView : UICollectionView! {
        didSet{
            self.collectionView.register(UINib.init(nibName: "ItemMapActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellActivity")
            self.collectionView.register(UINib.init(nibName: "ItemMapServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellService")
        }
    }
    
    func RadiansToDegrees(radians: Double) -> Double {
        return radians * 190.0/Double.pi
    }
    
    func DegreesToRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Config NavController
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.isTranslucent = true
        
        let gradient = CAGradientLayer()
        var bounds = self.navigationController?.navigationBar.bounds
        bounds?.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds!
        gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]

        if let image = getImageFrom(gradientLayer: gradient) {
            self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        }
        
        self.locationManagerConfiguration()
        self.configSearchBar()
    }
    
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager.startUpdatingLocation()
        self.stopTimer = true
        if listActivitiesFilter.count == 1{
            let activity = listActivitiesFilter[0]
            getRouteMap(latB: activity.act_latitude, lonB: activity.act_longitude)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.timer != nil {
            if self.stopTimer{
                self.timer.invalidate()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setBckStatusBarStryle(type: "clear")
        UIView.animate(withDuration: 0.5) {
            self.tabBarController?.tabBar.isHidden = self.hideTabbar
        }
        
        if collectionView == nil {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            flowLayout.minimumLineSpacing = 10.0
            flowLayout.minimumInteritemSpacing = 10.0
            
            self.collectionView = UICollectionView(frame: CGRect(x: 0, y: self.view.frame.height - UIDevice().getPositionCollActivities(), width: self.view.frame.width, height: heightColActivities), collectionViewLayout: flowLayout)
            self.collectionView.backgroundColor = UIColor.clear
            //self.collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.btnFilter = UIButton(frame: CGRect(x: self.view.frame.width - 63 , y: self.collectionView.frame.origin.y - 68, width: 50, height: 50))
            self.btnFilter.setImage(UIImage(named: "Icons/ico_filter"), for: .normal)
            self.btnFilter.imageView?.contentMode = .scaleAspectFill
            self.btnFilter.dropShadow(color: UIColor.black.withAlphaComponent(0.6), opacity: 1.0, offSet: CGSize(width: 0, height: 10), radius: 5, scale: false, corner: self.btnFilter.frame.width / 2, backgroundColor: Constants.COLORS.GENERAL.bgBtnGrad1B)
            self.btnFilter.addTarget(self, action: #selector(self.showhideSlide), for: UIControl.Event.touchUpInside)
            self.sideMenu = SideMapView()
            self.sideMenu.mapViewController = self
            
            if self.isFirst.boolValue {
                animateFilterFirst()
            }
            
            self.view.addSubview(self.collectionView)
            self.view.addSubview(self.btnFilter)
            UIApplication.shared.keyWindow?.addSubview(self.sideMenu)
        }
    }
    
    func animateFilterFirst(){
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                       self?.btnFilter.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        
        }) { (success) in
            UIView.animate(withDuration: 1.0,
                           delay: 0.5,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            self?.btnFilter.transform = .identity
                            
            }) { (success) in
                if self.isFirst.boolValue {
                    self.animateFilterFirst()
                }
            }
        }
    }
    
    override func loadView() {
        if mapView == nil {
            self.mapInfo = appDelegate.itemMapSelected
            self.typeCollection = TypeEntity.activities
            self.listAllActivities = appDelegate.listActivitiesByPark
            if listActivitiesFilter.count == 0 {
                self.listActivitiesFilter = appDelegate.listActivitiesByPark
            }
            self.listAllServices = appDelegate.listServicesLocationByPark
            self.listServicesFilter = appDelegate.listServicesLocationByPark
            
            let camera = GMSCameraPosition.camera(withLatitude: mapInfo.latitude, longitude: mapInfo.longitude, zoom: mapInfo.defaultZoom)
            self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            self.mapView.settings.tiltGestures = false
            self.mapView.settings.rotateGestures = false
            self.mapView.settings.compassButton = true
            self.mapView.setMinZoom(mapInfo.minZoom, maxZoom: self.mapInfo.maxZoom)
            let coorBounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: mapInfo.limitA_lat, longitude: mapInfo.limitA_long), coordinate: CLLocationCoordinate2D(latitude: mapInfo.limitB_lat, longitude: mapInfo.limitB_long))
            self.mapView.cameraTargetBounds = coorBounds
            self.mapView.camera(for: coorBounds, insets: UIEdgeInsets())
            self.mapView.delegate = self
            
            do {
                // Set the map style by passing a valid JSON string.
                self.mapView.mapStyle = try GMSMapStyle(jsonString: self.mapInfo.style)
            } catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
            
            self.view = mapView
            
            showOverlayer()
            setMapPointsActivities()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func locationManagerConfiguration() {
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.distanceFilter = 50.0
            self.locationManager.activityType = .fitness
            self.locationManager.pausesLocationUpdatesAutomatically = true
            //self.locationManager.startUpdatingHeading()
        }else{
            self.locationManager.stopUpdatingLocation()
            print("no tiene permisos")
        }
    }
    
    private func inThePark(lat: Double, lon: Double) -> Bool {
        let coord1 = CLLocation(latitude: lat, longitude: lon)
        let coord2 = CLLocation(latitude: self.mapInfo.latitude, longitude: self.mapInfo.longitude)
        let distance = ceil(coord1.distance(from: coord2) / 1000)
        return distance <= 1.5
    }
    
    func getRouteMap(latB: String, lonB: String){
        if intoThePark {
            if self.polylineMap != nil{
                self.polylineMap.map = nil
                self.animationPolyline.map = nil
                self.timer.invalidate()
            }
            //Nuestra ubicacion
            //let lat = self.locationManager.location?.coordinate.latitude
            //let long = self.locationManager.location?.coordinate.longitude
            //Verificamos si tenemos conexion con internet
            /*if Connectivity.isConnectedToInternet{
                LoadingView.shared.showActivityIndicator(uiView: self.mapView)
                MapDB.shared.getRouteMapPath(latA: "\(lat!)", lonA: "\(long!)", latB: latB, lonB: lonB) { (path) in
                    DispatchQueue.main.async {
                        LoadingView.shared.hideActivityIndicator(uiView: self.mapView)
                        self.path = path
                        self.polylineMap = GMSPolyline.init(path: path)
                        self.polylineMap.strokeColor = UIColor(red: 250/255, green: 224/255, blue: 2/255, alpha: 0.5)
                        self.polylineMap.strokeWidth = 5
                        self.polylineMap.geodesic = true
                        self.polylineMap.map = self.mapView
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.animatePolylinePath), userInfo: nil, repeats: true)
                    }
                }
            }*/
        }
    }
    
    @objc func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor(red: 254/255, green: 119/255, blue: 28/255, alpha: 1) //250/224/2 Amarillo // 254/119/28
            self.animationPolyline.strokeWidth = 5
            self.animationPolyline.geodesic = true
            self.animationPolyline.map = self.mapView
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    
    func showOverlayer(){
        let southWest = CLLocationCoordinate2D(latitude: mapInfo.overSW_lat, longitude: mapInfo.overSW_long)
        let northEast = CLLocationCoordinate2D(latitude: mapInfo.overNE_lat, longitude: mapInfo.overNE_long)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        
        let icon = UIImage(named: self.mapInfo.imgOverlay)
        let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: icon)
        overlay.map = mapView
    }
    
    func showhideControlsMap(){
        if self.btnFilter.frame.origin.y < self.view.frame.height{
            self.hideControlsMap(hideSearch: true)
            
        }else{
            self.showControlsMap(showSearch: true)
        }
    }
    
    func hideControlsMap(hideSearch: Bool = false){
        if self.btnFilter.frame.origin.y < self.view.frame.height {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCurlUp, animations: {
                self.btnFilter.frame.origin.y = self.btnFilter.frame.origin.y + self.view.frame.height
                self.collectionView.frame.origin.y = self.collectionView.frame.origin.y + self.view.frame.height
                self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
                if hideSearch {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                }
            })
        }
    }
    
    func showControlsMap(showSearch: Bool = false){
        if self.btnFilter.frame.origin.y > self.view.frame.height{
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCurlUp, animations: {
                self.collectionView.frame.origin.y = self.collectionView.frame.origin.y - self.view.frame.height
                self.btnFilter.frame.origin.y =  self.btnFilter.frame.origin.y - self.view.frame.height
                self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.collectionView.frame.height, right: 0)
                if showSearch {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
            })
        }
    }
    
    func setMapPointsActivities(){
        var countAct = 1
        for activity in listActivitiesFilter{
            let markerPin = GMSMarker(position: activity.getLocation())
            markerPin.userData = activity
            markerPin.appearAnimation = .pop
            
            if countAct == 1{
                markerPin.iconView = MarkerView.shared.setPinSelectActivity(title: activity.act_number, colorPin: activity.route.getColorPoint, colorCode: activity.route.r_code)
                self.markerSelectedInMap = markerPin
                self.mapView.animate(toLocation: activity.getLocation())
                self.mapView.animate(toZoom: self.mapInfo.minZoom)
            }else{
                markerPin.iconView = MarkerView.shared.setPinActivity(title: activity.act_number, colorPin: activity.route.getColorPoint, colorCode: activity.route.r_code)
            }
            countAct += 1
            
            markerPin.map = self.mapView
            listMarkersAct.append(markerPin)
        }
    }
    
    func setMapPointsServices(){
        var countServ = 1
        for service in listServicesFilter {
            let markerServ = GMSMarker(position: service.getLocation())
            markerServ.userData = service
            
            if countServ == 1{
                markerServ.iconView = MarkerView.shared.setPinSelectedService(itemServiceLocation: service)
                self.markerSelectedInMap = markerServ
                self.mapView.animate(toLocation: service.getLocation())
                self.mapView.animate(toZoom: self.mapInfo.minZoom)
            }else{
                markerServ.iconView = MarkerView.shared.setPinService(codeServ: service.service.serv_code)
            }
            countServ += 1
            
            markerServ.map = self.mapView
            listMarkersServ.append(markerServ)
        }
    }
    
    
    func removeMarker(){
        for index in listMarkersAct{
            index.map = nil
        }
        
        for index in listMarkersServ{
            index.map = nil
        }
        listMarkersServ = [GMSMarker]()
        listMarkersAct = [GMSMarker]()
    }
    
    func setPositionActivity(marker: GMSMarker){
        if typeCollection == TypeEntity.activities {
            if let index = listMarkersAct.firstIndex(of: marker){
                let indexPath = IndexPath(item: index, section: 0)
                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                let itemAct = listActivitiesFilter[index]
                
                //Animamos el cambio de PIN
                if let selectedMarker = self.markerSelectedInMap {
                    let itemSelected = self.markerSelectedInMap?.userData as! ItemActivity
                    selectedMarker.iconView? = MarkerView.shared.setPinActivity(title: itemSelected.act_number, colorPin: itemSelected.route.getColorPoint, colorCode: itemSelected.route.r_code)
                }
                marker.iconView = MarkerView.shared.setPinSelectActivity(title: itemAct.act_number, colorPin: itemAct.route.getColorPoint, colorCode: itemAct.route.r_code)
                
            }
        }
        
        if typeCollection == TypeEntity.services{
            if let index = listMarkersServ.firstIndex(of: marker){
                let indexPath = IndexPath(item: index, section: 0)
                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                let itemServ = listServicesFilter[index]
                //Animamos el cambio de PIN
                
                if let selectedMarker = self.markerSelectedInMap { //self.mapView.selectedMarker {
                    selectedMarker.iconView? = MarkerView.shared.setPinService(codeServ: itemServ.service.serv_code)
                }
                marker.iconView = MarkerView.shared.setPinSelectedService(itemServiceLocation: itemServ)
            }
        }
        
        showControlsMap()
        self.markerSelectedInMap = marker
        self.markerSelectedInMap!.zIndex = 1
        //Movemos camera hacia el pin seleccionado
        let point = mapView.projection.point(for: marker.position)
        let camera = mapView.projection.coordinate(for: point)
        let position = GMSCameraUpdate.setTarget(camera)
        mapView.animate(with: position)
    }
    
    func showAlert(type : String){
        let titleAlert = type == "F" ? "lbl_title_not_fav".getNameLabel()/*"lblTitleNotFav".localized()*/ : "lbl_title_not_result".getNameLabel()//"lblTitleNotResult".localized()
        let descriptionAlert =  type == "F" ? "lbl_desc_not_fav".getNameLabel()/*"lblDescNotFav".localized()*/ : "lbl_desc_not_result".getNameLabel()//"lblDescNotResult".localized()
        let imageAlert = type == "F" ? "agregar_favoritos" : "help"
        let alertVC = PMAlertController(title: titleAlert, description: descriptionAlert, image: UIImage(named: "Alert/\(imageAlert)"), style: .alert)
        alertVC.headerViewTopSpaceConstraint.constant = 0
        alertVC.headerView.backgroundColor = UIColor.gray
        alertVC.alertView.cornerRadius = 20
        alertVC.headerView.cornerRadius = 20
        alertVC.headerViewHeightConstraint.constant = 130
        alertVC.alertImage.cornerRadius = 20
        alertVC.alertImage.contentMode = .scaleAspectFill
        alertVC.addAction(PMAlertAction(title: "lbl_accept".getNameLabel()/*"lblAccept".localized()*/, style: .default, action: { () in
            print("Capture action OK")
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func showhideSlide() {
        if self.isFirst.boolValue {
            AppUserDefaults.save(value: false, forKey: .FirstInteracionFilter)
            self.isFirst = AppUserDefaults.value(forKey: .FirstInteracionFilter, fallBackValue: true)
        }
        self.sideMenu.showhideSlide()
    }
    
    func filterResults(type: TypeEntity, code: String, subfilter: String){
        //Inicializamos el marcador actual
        self.markerSelectedInMap = nil
        if self.polylineMap != nil{
            self.polylineMap.map = nil
            self.animationPolyline.map = nil
            self.timer.invalidate()
        }
        
        print("Tipo \(type) - Code \(code) - subcode \(subfilter)")
        var heightCollView : CGFloat = 0.0
        var positionYCollView : CGFloat = 100.0
        self.typeCollection = type
        
        switch type {
        case .activities:
            heightCollView = heightColActivities
            positionYCollView = UIDevice().getPositionCollActivities()
            
            if subfilter == "SEARCH"{
                if !code.isEmpty{
                    LoadingView.shared.showActivityIndicator(uiView: self.view)
                    FirebaseBR.shared.searchActivitiesByName(searchText: code) { (listSearchActivitites) in
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        self.listActivitiesFilter = listSearchActivitites
                        if listSearchActivitites.count == 0{
                            self.showAlert(type: "S")
                        }
                    }
                }else{
                    listActivitiesFilter = listAllActivities
                }
            }else{
                searchBar?.text = ""
                if code == "ALL" {
                    listActivitiesFilter = listAllActivities
                }else if code == "FAV" {
                    FirebaseBR.shared.getFavorites { (listFavorites) in
                        if listFavorites.count > 0 {
                            self.listActivitiesFilter = listFavorites
                        }else{
                            self.showAlert(type: "F")
                        }
                    }
                }else if code == "ROUTES" {
                    listActivitiesFilter = listAllActivities.filter({$0.route.r_code == subfilter })
                }
                else{
                    listActivitiesFilter = listAllActivities.filter({ $0.category.cat_code == code})
                }
            }
            
            self.removeMarker()
            self.setMapPointsActivities()
            
        case .services:
            searchBar?.text = ""
            heightCollView = heightColServices
            positionYCollView = UIDevice().getPositionCollServices()
            listServicesFilter = listAllServices.filter({ $0.service.serv_code == (subfilter.isEmpty ? code : subfilter)})
            self.removeMarker()
            self.setMapPointsServices()
        default:
            heightCollView = heightColActivities
            positionYCollView = UIDevice().getPositionCollActivities()
            listActivitiesFilter = listAllActivities
        }
        
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Filters.rawValue, title: "\(code)\(!subfilter.isEmpty ? "_\(subfilter)" : "")")
        
        if (typeCollection == TypeEntity.activities && listActivitiesFilter.count > 0) || (typeCollection == TypeEntity.services && listServicesFilter.count > 0) {
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCrossDissolve, animations: {
                print("Position \(positionYCollView) height \(heightCollView) Y \(self.view.frame.height - (positionYCollView))")
                self.collectionView.frame = CGRect(x: 0, y: self.view.frame.height - (positionYCollView), width: self.view.frame.width, height: heightCollView)
                self.btnFilter.frame.origin.y = self.collectionView.frame.origin.y - (self.intoThePark ? 140 : 68)
                self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: heightCollView, right: 0)
            }) { (success) in
                self.collectionView.reloadData()
                if self.listActivitiesFilter.count > 0 {
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally , animated: true)
                }
            }
        }else{
            hideControlsMap()
            collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goMapDetailAct" {
            if let detailActivity = segue.destination as? DetailActivityViewController{
                detailActivity.isCallToMap = true
                detailActivity.itemActivity = activitySelected
            }
        }
    }
    
    func configSearchBar(){
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 50))
        searchBar?.placeholder = "lbl_search".getNameLabel()//"lblSearch".localized()
        searchBar?.delegate = self
        if #available(iOS 13.0, *) {
            searchBar?.searchBarStyle = .default
            searchBar?.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        }
        self.navigationItem.titleView = searchBar
    }
    
    func filterActivities(searchText: String, isCancel: Bool){
        filterResults(type: .activities, code: searchText.lowercased(), subfilter: "SEARCH")
    }
}

extension MapViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GoRouteMapDelegate, GoRouteServDelegate {
    func goToServ(service: ItemServicesLocation) {
        //getRouteMap(latB: service.s_latitude, lonB: service.s_longitude)
    }
    
    func goToMap(activity: ItemActivity) {
        print("GoMap")
        getRouteMap(latB: activity.act_latitude, lonB: activity.act_longitude)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if typeCollection == TypeEntity.activities{
            return listActivitiesFilter.count
        }else{
            return listServicesFilter.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if typeCollection == TypeEntity.activities{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellActivity", for: indexPath) as? ItemMapActivityCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.configureCell(itemActivity: listActivitiesFilter[indexPath.row])
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellService", for: indexPath) as? ItemMapServiceCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.configureCell(item: listServicesFilter[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizeColl = CGSize()
        if typeCollection == TypeEntity.activities{
            sizeColl = CGSize(width: self.view.frame.width - 70, height: heightColActivities)
        }else{
            sizeColl = CGSize(width: self.view.frame.width - 80, height: heightColServices)
        }
        print(sizeColl)
        return sizeColl
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.stopTimer = false
        if typeCollection == TypeEntity.activities && listActivitiesFilter.count > 0{
            self.activitySelected = listActivitiesFilter[indexPath.row]
            self.performSegue(withIdentifier: "goMapDetailAct", sender: nil)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        if self.collectionView.isDecelerating{
            print("isDecelerating")
        }else{
            print("Not isDecelerating")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        print("isDecelerating = false")
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
            
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
            
        if typeCollection == TypeEntity.activities{
            let markerSelected : GMSMarker = listMarkersAct[indexPath.row]
            self.setPositionActivity(marker: markerSelected)
        }
                
        if typeCollection == TypeEntity.services{
            let markerSelected : GMSMarker = listMarkersServ[indexPath.row]
            self.setPositionActivity(marker: markerSelected)
        }
    }
}

extension MapViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.setPositionActivity(marker: marker)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("didtapat")
        showhideControlsMap()
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let lat = mapView.myLocation?.coordinate.latitude,
            let lng = mapView.myLocation?.coordinate.longitude else { return false }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: mapInfo.maxZoom)
        mapView.animate(to: camera)
        return true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.coords = manager.location?.coordinate
        self.intoThePark = self.inThePark(lat: self.coords.latitude, lon: self.coords.longitude)
        
        if self.isInit {
            self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.collectionView.frame.height, right: 0)
            if intoThePark {
                self.mapView.animate(toLocation: self.coords)
            }else {
                self.locationManager.stopUpdatingLocation()
            }
            self.isInit = false
        }
        
        if intoThePark {
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
            self.btnFilter.frame.origin.y = self.collectionView.frame.origin.y - 140
        }
        else {
            self.mapView.isMyLocationEnabled = false
            self.mapView.settings.myLocationButton = false
            self.btnFilter.frame.origin.y = self.collectionView.frame.origin.y - 68
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            UpAlertView(type: .warning, message: "txt_alert_location_denied".getNameLabel()).show{//"alertLocationDenied".localized()).show{
                print("error")
            }
        case .notDetermined:
            print("Location status not determined.")
            self.locationManager.requestAlwaysAuthorization()
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        default:
            print("ocurrió un error no reconocido")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
    }
}

extension MapViewController : UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .black
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        guard let term = searchBar.text, term.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty == false else {
            return
        }
        
        //Filter function
        self.filterActivities(searchText: term, isCancel: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
        
        //Filter function
        self.filterActivities(searchText: searchBar.text!, isCancel: true)
    }
}
