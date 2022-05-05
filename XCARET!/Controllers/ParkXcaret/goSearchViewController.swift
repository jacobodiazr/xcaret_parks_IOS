//
//  goSearchViewController.swift
//  XCARET!
//
//  Created by Hate on 30/11/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly

class goSearchViewController: UIViewController, SilentScrollable {

    private let tableHeaderViewHeight: CGFloat = UIDevice().getHeightSearch()
    private let tableHeaderViewCutaway: CGFloat = 0
    var silentScrolly: SilentScrolly?
    var headerView: SearchHeaderView!
    let closeButton = UIButton()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var listActivities : [ItemActivity] = [ItemActivity]()
    var listActMap : [ItemActivity] = [ItemActivity]()
    var typeCellEmpty : TypeEmptyCell = .searchinfo
    var activitySelected = ItemActivity()
    var listItemSection : [ItemSection] = [ItemSection]()
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblSearch.estimatedRowHeight = UITableView.automaticDimension
        self.tblSearch.showsVerticalScrollIndicator = false
        self.configHeaderTableView()
        self.addNavigationBar()
        self.setSectionsTable()
        
    }
    
    
    private func addNavigationBar() {
        let height: CGFloat = 75
        var statusBarHeight: CGFloat = 0
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = .clear
        navbar.barTintColor = .clear
        
        navbar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navbar.shadowImage = UIImage()
        navbar.isTranslucent = true
        self.setBckStatusBarStryle(type: "")
        
        let statusBarFrame = UIApplication.shared.statusBarFrame
        let statusBarView = UIView(frame: statusBarFrame)
        self.view.addSubview(statusBarView)
        statusBarView.backgroundColor = .clear
        
        navbar.delegate = self as? UINavigationBarDelegate
        
        let searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: statusBarHeight, width: (self.view.frame.width) - 65, height: 50))
        searchBar.placeholder = "lbl_search".getNameLabel()//"lblSearch".localized()
        searchBar.delegate = self
        if #available(iOS 13.0, *) {
            searchBar.searchBarStyle = .default
            searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        }
        
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        
        let imageView = UIImageView(frame: CGRect(x: -7, y: 0, width: 30, height: 25))
        imageView.contentMode = .scaleAspectFill
        let image = UIImage(named: "Icons/photo/ic_regresar")
        imageView.image = image
        logoContainer.addSubview(imageView)
        //            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoContainer)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.goBack))
        logoContainer.addGestureRecognizer(gesture)
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(customView: logoContainer)//UIBarButtonItem(image: logo, landscapeImagePhone: logo, style: .plain, target: self, action: #selector(goBack))
        navItem.rightBarButtonItem = leftNavBarButton
        
        navbar.items = [navItem]
        
        view.addSubview(navbar)
        
        self.view?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func configHeaderTableView(){
        headerView = (tblSearch.tableHeaderView as! SearchHeaderView)
        tblSearch.tableHeaderView = nil
        tblSearch.addSubview(headerView)
        tblSearch.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tblSearch.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
        updateHeaderView()
    }
    
    func updateHeaderView()
    {
        
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect()
        
        headerRect = CGRect(x: 0, y: -effectiveHeight, width: self.view.frame.width, height: tableHeaderViewHeight)
        
        
        if tblSearch.contentOffset.y < -effectiveHeight {
            self.setBckStatusBarStryle(type: "")
            headerRect.origin.y = tblSearch.contentOffset.y
            headerRect.size.height = (-tblSearch.contentOffset.y) + tableHeaderViewCutaway/2

        }else{
            self.setBckStatusBarStryle(type: "")
        }
        
        headerView.frame = headerRect
    }
    
     
    
    override func viewWillAppear(_ animated: Bool) {
       
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

        FirebaseBR.shared.searchActivitiesByName(searchText: searchText.lowercased()) { (listSearchActivitites) in
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            self.listActivities = listSearchActivitites
            self.typeCellEmpty = isCancel == true ? .searchinfo : .notfound
            self.setSectionsTable()
        }
//    }
    }
    
    func setSectionsTable(){
        self.listItemSection = [ItemSection]()
        
        if self.listActivities.count > 0{
                
                let groupPakActivities = Dictionary(grouping: self.listActivities ) { (event) -> String in
                    return event.act_keyPark
                }
                for value in groupPakActivities.sorted(by: { $0.key < $1.key }) {
//
//                    let sectionTitleSearch : ItemSection = ItemSection()
//                    sectionTitleSearch.type = "TITLE"
//                    sectionTitleSearch.totalElements = 1
//
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
//                        self.listItemSection.append(sectionTitleSearch)
                        self.listItemSection.append(sectionTitle)
                        self.listItemSection.append(sectionActivitites)
                    }
                }
        }else{
            
            let sectionEmpty : ItemSection = ItemSection()
            sectionEmpty.type = "EMPTY"
            sectionEmpty.totalElements = 1
            self.listItemSection.append(sectionEmpty)
        }
        self.tblSearch.reloadData()
    }
}


extension goSearchViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
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
//                    cell.delegateMap = self
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
//                cell.delegateMap = self
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
    
    
    
    private func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        view.endEditing(true)
        silentDidScroll()
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        showNavigationBar()
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterActivities(searchText: searchText, isCancel: true)
    }


}
