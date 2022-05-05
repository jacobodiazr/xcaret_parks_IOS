//
//  SearchViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 11/21/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly

class SearchViewController: UIViewController, SilentScrollable {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var listActivities : [ItemActivity] = [ItemActivity]()
    var listActMap : [ItemActivity] = [ItemActivity]()
    var typeCellEmpty : TypeEmptyCell = .searchinfo
    var activitySelected = ItemActivity()
    var listItemSection : [ItemSection] = [ItemSection]()
    
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var tblSearch: UITableView! {
        didSet{
            tblSearch.register(UINib(nibName: "ItemActHorizontalTableViewCell", bundle: nil), forCellReuseIdentifier: "cellActivity")
            tblSearch.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "cellEmpty")
            tblSearch.register(UINib(nibName: "ItemTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "cellTitle")
            tblSearch.register(UINib(nibName: "ItemActSimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSimple")
            tblSearch.delegate = self
            tblSearch.dataSource = self
        }
    }
    
    private var tableHeaderViewHeight: CGFloat = UIDevice().getHeightHeader()
    
    private let tableHeaderViewCutaway: CGFloat = 0
    var headerView: SearchHeaderView!
    var silentScrolly: SilentScrolly?
    
    @IBOutlet weak var viewContentBackSearch: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var constraintBack: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.tblSearch.estimatedRowHeight = UITableView.automaticDimension
        self.tblSearch.showsVerticalScrollIndicator = false
        viewContentBackSearch.isHidden = true
        if appDelegate.optionsHome {
            self.viewContentBackSearch.isHidden = false
            tableHeaderViewHeight = UIDevice().getHeightHeaderHome()
            constraintBack.constant = UIDevice().getHeightHomeMenu()
        }
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.viewBack.addGestureRecognizer(tapRecognizer)
        self.configHeaderTableView()
        self.configSearchBar()
        self.setSectionsTable()
        
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnSendMap(_ sender: UIButton) {
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Search.rawValue, title: TagsID.goMap.rawValue)
        listActMap = listActivities
        self.performSegue(withIdentifier: "goSearchMap", sender: nil)
    }
    
    func configHeaderTableView(){
        headerView = (tblSearch.tableHeaderView as! SearchHeaderView)
        tblSearch.tableHeaderView = nil
        tblSearch.addSubview(headerView)
        tblSearch.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tblSearch.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
        updateHeaderView()
    }
    
    func configSearchBar(){
        var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 50))
        searchBar.placeholder = "lbl_search".getNameLabel()//"lblSearch".localized()
        searchBar.delegate = self
        
        if #available(iOS 13.0, *) {
            searchBar.searchBarStyle = .default
            searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        }
        
        
        
        if appDelegate.optionsHome{
            searchBar = UISearchBar(frame: CGRect(x: 50, y: UIDevice().getTopHomeSearch(), width: (self.view.frame.width - 60), height: 50))
            searchBar.placeholder = "lbl_search".getNameLabel()//"lblSearch".localized()
            searchBar.delegate = self
            
            if #available(iOS 13.0, *) {
                searchBar.searchBarStyle = .minimal
                searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            }
            self.viewContentBackSearch.addSubview(searchBar)
        }else{
            let leftNavBarButton = UIBarButtonItem(customView: searchBar)
            self.navigationItem.leftBarButtonItem = leftNavBarButton
        }
        
        
    }
    
//    func updateHeaderView()
//    {
//        if appDelegate.optionsHome{
//            print(tableHeaderViewHeight)
//            print(tableHeaderViewCutaway/2)
//            let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
//            var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tblSearch.bounds.width, height: tableHeaderViewHeight)
//
//            if tblSearch.contentOffset.y < -effectiveHeight {
//                self.setBckStatusBarStryle(type: "clear")
//                headerRect.origin.y = tblSearch.contentOffset.y
//                headerRect.size.height = tableHeaderViewHeight//-tblSearch.contentOffset.y + tableHeaderViewCutaway/2
//            }else{
//                self.setBckStatusBarStryle(type: "")
//            }
//            headerView.frame = headerRect
//        }else{
//            let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
//            var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tblSearch.bounds.width, height: tableHeaderViewHeight)
//
//            if tblSearch.contentOffset.y < -effectiveHeight {
//                self.setBckStatusBarStryle(type: "clear")
//                headerRect.origin.y = tblSearch.contentOffset.y
//                headerRect.size.height = -tblSearch.contentOffset.y + tableHeaderViewCutaway/2
//            }else{
//                self.setBckStatusBarStryle(type: "")
//            }
//            headerView.frame = headerRect
//        }
//    }
    
    
    func updateHeaderView()
    {
        if appDelegate.optionsHome{
            let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
            var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tblSearch.bounds.width, height: tableHeaderViewHeight)
            if tblSearch.contentOffset.y < -effectiveHeight {
            self.setBckStatusBarStryle(type: "clear")
            self.navigationController?.navigationBar.isHidden = true

                tblSearch.contentOffset.y = -effectiveHeight
                headerRect.origin.y = tblSearch.contentOffset.y
                headerRect.size.height = tableHeaderViewHeight//-tblSearch.contentOffset.y + tableHeaderViewCutaway/2
            }else{
                self.setBckStatusBarStryle(type: "")
            }
            headerView.frame = headerRect
        }else{
            let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
            var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tblSearch.bounds.width, height: tableHeaderViewHeight)

            if tblSearch.contentOffset.y < -effectiveHeight {
                self.setBckStatusBarStryle(type: "clear")
                headerRect.origin.y = tblSearch.contentOffset.y
                headerRect.size.height = -tblSearch.contentOffset.y + tableHeaderViewCutaway/2
            }else{
                self.setBckStatusBarStryle(type: "")
            }
            headerView.frame = headerRect
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(tblSearch, followBottomView: tabBarController?.tabBar)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        silentWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        silentDidDisappear()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        silentWillTranstion()
    }
    
    func filterActivities(searchText: String, isCancel: Bool){
        
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        if appDelegate.optionsHome{
            FirebaseBR.shared.searchActivitiesHome(searchText: searchText.lowercased()) { (listSearchActivitites) in
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                self.listActivities = listSearchActivitites
                self.typeCellEmpty = isCancel == true ? .searchinfo : .notfound
                //self.btnMap.isHidden = listSearchActivitites.count > 0 ? false : true
                //self.tblSearch.reloadData()
                self.setSectionsTable()
            }
        }else{
        FirebaseBR.shared.searchActivitiesByName(searchText: searchText.lowercased()) { (listSearchActivitites) in
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            self.listActivities = listSearchActivitites
            self.typeCellEmpty = isCancel == true ? .searchinfo : .notfound
            //self.btnMap.isHidden = listSearchActivitites.count > 0 ? false : true
            //self.tblSearch.reloadData()
            self.setSectionsTable()
        }
    }
    }
    
    func setSectionsTable(){
        self.listItemSection = [ItemSection]()
        if self.appDelegate.itemParkSelected.code == "XS"{
            
        }else{
            
            self.btnMap.isHidden = self.listActivities.count > 0 ? false : true
            if appDelegate.optionsHome {
                self.btnMap.isHidden = true
            }
        }
        if self.listActivities.count > 0{
            
            if !appDelegate.optionsHome {
            let sectionTitle : ItemSection = ItemSection()
            sectionTitle.type = "TITLE"
            sectionTitle.totalElements = 1
                
            let sectionActivitites : ItemSection = ItemSection()
            sectionActivitites.type = "ACT"
            sectionActivitites.totalElements = self.listActivities.count
                
            self.listItemSection.append(sectionTitle)
            self.listItemSection.append(sectionActivitites)
            }else{
                
                let groupPakActivities = Dictionary(grouping: self.listActivities ) { (event) -> String in
                    return event.act_keyPark
                }
                for value in groupPakActivities.sorted(by: { $0.key < $1.key }) {
                    let sectionTitle : ItemSection = ItemSection()
                    sectionTitle.type = "TITLEHOME"
                    sectionTitle.totalElements = 1
                    sectionTitle.uid = value.key
                    
                    let sectionActivitites : ItemSection = ItemSection()
                    sectionActivitites.type = "ACTHOME"
                    sectionActivitites.totalElements = value.value.count
                    sectionActivitites.uid = value.key
                    let noXoxi = appDelegate.listAllParks.filter({$0.uid == value.key})
                    if noXoxi.first?.code != "XO" {
                        self.listItemSection.append(sectionTitle)
                        self.listItemSection.append(sectionActivitites)
                    }
                    
                    
                }
                
            }
            
            
        }else{
            
            let sectionEmpty : ItemSection = ItemSection()
            sectionEmpty.type = "EMPTY"
            sectionEmpty.totalElements = 1
            
            if !appDelegate.optionsHome{
                let sectionTitle : ItemSection = ItemSection()
                sectionTitle.type = "TITLE"
                sectionTitle.totalElements = 1
                self.listItemSection.append(sectionTitle)
            }
            
            self.listItemSection.append(sectionEmpty)
        }
        self.tblSearch.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSearchMap" {
            if let mapController = segue.destination as? MapViewController {
                mapController.hideTabbar = true
                mapController.listActivitiesFilter = listActMap
            }
        }else if segue.identifier == "goSearchDetailAct" {
            if let detailActivity = segue.destination as? DetailActivityViewController{
                detailActivity.itemActivity = activitySelected
            }
        }
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource, GoRouteMapDelegate {
    func goToMap(activity: ItemActivity) {
        listActMap = [activity]
        self.performSegue(withIdentifier: "goSearchMap", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listItemSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItemSection[section].totalElements
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemSection = self.listItemSection[indexPath.section]
        let listAllParks = appDelegate.listAllParks
        
            switch itemSection.type {
            case "ACT":
                if appDelegate.itemParkSelected.code == "XS"{
                    let cell : ItemActSimpleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellSimple", for: indexPath) as! ItemActSimpleTableViewCell
                    let indexList = indexPath.row
                    let itemActivity = self.listActivities[indexList]
                    cell.setInformation(itemActivity: itemActivity, sectionFav: false)
                    return cell
                }else{
                    let cell : ItemActHorizontalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActHorizontalTableViewCell
                    let indexList = indexPath.row
                    let itemActivity = self.listActivities[indexList]
                    cell.delegateMap = self
                    cell.contentID = TagsContentAnalytics.Search.rawValue
                    cell.setInformation(itemActivity: itemActivity, sectionFav: false)
                    return cell
                }
                
            case "TITLE":
                
                let cell : ItemTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as! ItemTitleTableViewCell
                cell.lblTitle.text = "lbl_my_search".getNameLabel()//"lblMySearch".localized()
                return cell
            case "TITLEHOME":
                
                let cell : ItemTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as! ItemTitleTableViewCell
                
                print()
                let park = listAllParks.filter({$0.uid == itemSection.uid})
                cell.lblTitle.text = park.first?.name
                return cell
                
            case "ACTHOME":
                let cell : ItemActHorizontalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActHorizontalTableViewCell
                let indexList = indexPath.row
                let listAc = listActivities.filter({$0.act_keyPark == itemSection.uid})
                let itemActivity = listAc[indexList]
                cell.delegateMap = self
                cell.contentID = TagsContentAnalytics.Search.rawValue
                cell.setInformation(itemActivity: itemActivity, sectionFav: false)
                return cell
                
            default:
                let cell : EmptyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellEmpty", for: indexPath) as! EmptyTableViewCell
                cell.setInformation(type: typeCellEmpty)
                //cell.lblTitleSection.text = "lblMySearch".localized()
                return cell
                
            }
            
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemSection = self.listItemSection[indexPath.section]
        if itemSection.type == "ACT"{
            self.activitySelected = listActivities[indexPath.row]
            self.performSegue(withIdentifier: "goSearchDetailAct", sender: nil)
        }
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var newHeight: CGFloat = 60.0
//        if indexPath.row == 0 {
//            newHeight = newHeight + CGFloat(UIDevice().getHeightViewCode() - 10)
//        }
//        if indexPath.row == 1{
//            newHeight = UITableView.automaticDimension
//        }
//        return newHeight
//    }
    
    private func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        silentDidScroll()
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        showNavigationBar()
        return true
    }
}

