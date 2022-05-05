//
//  FavoriteViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 11/28/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly

class FavoriteViewController: UIViewController, SilentScrollable {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let tableHeaderViewHeight: CGFloat = UIDevice().getHeightHeader()
    private let tableHeaderViewCutaway: CGFloat = 0
    var headerView: FavoriteHeaderView!
    var silentScrolly: SilentScrolly?
    var listActFavorites : [ItemActivity] = [ItemActivity]()
    var listActMap : [ItemActivity] = [ItemActivity]()
    var activitySelected = ItemActivity()
    var listItemSection : [ItemSection] = [ItemSection]()
    var listItemSectionHome : [ItemSection] = [ItemSection]()
    
    

    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var tblFavorites: UITableView! {
        didSet{
            tblFavorites.register(UINib(nibName: "ItemActHorizontalTableViewCell", bundle: nil), forCellReuseIdentifier: "cellActivity")
            tblFavorites.register(UINib(nibName: "ItemTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "cellTitle")
            tblFavorites.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "cellEmpty")
            tblFavorites.register(UINib(nibName: "ItemActSimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSimple")
            tblFavorites.delegate = self
            tblFavorites.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.tblFavorites.estimatedRowHeight = UITableView.automaticDimension
        self.tblFavorites.showsVerticalScrollIndicator = false
        self.configHeaderTableView()
        self.configDarkModeCustom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.configDarkModeCustom()
        loadInformation()
    }
    
    func configDarkModeCustom(){
        headerView.configDarkModeCustom()
        tblFavorites.backgroundColor = appDelegate.itemParkSelected.code == "XF" ? Constants.COLORS.GENERAL.customDarkMode : .white
        tblFavorites.reloadData()
    }
    
    func configHeaderTableView(){
        headerView = (tblFavorites.tableHeaderView as! FavoriteHeaderView)
        headerView.lblName.text = "lbl_my_favorites".getNameLabel()//"lblMyFavorites".localized()
        tblFavorites.tableHeaderView = nil
        tblFavorites.addSubview(headerView)
        tblFavorites.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tblFavorites.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
        updateHeaderView()
    }
    
    func updateHeaderView()
    {
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tblFavorites.bounds.width, height: tableHeaderViewHeight)
        
        if tblFavorites.contentOffset.y < -effectiveHeight {
            self.setBckStatusBarStryle(type: "clear")
            headerRect.origin.y = tblFavorites.contentOffset.y
            headerRect.size.height = -tblFavorites.contentOffset.y + tableHeaderViewCutaway/2
        }else{
            self.setBckStatusBarStryle(type: "")
        }
        
        headerView.frame = headerRect
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(tblFavorites, followBottomView: tabBarController?.tabBar)
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
    
    func loadInformation(){
        FirebaseBR.shared.getFavorites { (listFavorites) in
            self.listItemSection = [ItemSection]()
            self.listActFavorites = listFavorites
            //Armamos las secciones de la tabla
           self.setSectionsTable()
        }
    }
    
    func setSectionsTable(){
        self.listItemSection = [ItemSection]()
        if self.appDelegate.itemParkSelected.code == "XS" || self.appDelegate.itemParkSelected.code == "XV" || self.appDelegate.itemParkSelected.code == "XF" || self.appDelegate.itemParkSelected.code == "XP"{
            self.btnMap.isHidden = true
        }else{
            self.btnMap.isHidden = self.listActFavorites.count > 0 ? false : true
        }
        if self.listActFavorites.count > 0{
            let sectionTitle : ItemSection = ItemSection()
            sectionTitle.type = "TITLE"
            sectionTitle.totalElements = 1
            
            let sectionActivitites : ItemSection = ItemSection()
            sectionActivitites.type = "ACT"
            sectionActivitites.totalElements = self.listActFavorites.count
            self.listItemSection.append(sectionTitle)
            self.listItemSection.append(sectionActivitites)
        }else{
            let sectionTitle : ItemSection = ItemSection()
            sectionTitle.type = "TITLE"
            sectionTitle.totalElements = 1
            
            let sectionEmpty : ItemSection = ItemSection()
            sectionEmpty.type = "EMPTY"
            sectionEmpty.totalElements = 1
            self.listItemSection.append(sectionTitle)
            self.listItemSection.append(sectionEmpty)
        }
        self.tblFavorites.reloadData()
    }
    
    @IBAction func btnSendMap(_ sender: UIButton) {
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Favorite.rawValue, title: TagsID.goMap.rawValue)
        /*SF*/
        let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_goMapf": true]
        (AppDelegate.getKruxTracker()).trackPageView("Favorites", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        self.listActMap = listActFavorites
        self.performSegue(withIdentifier: "goFavMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goFavMap" {
            if let mapController = segue.destination as? MapViewController {
                mapController.hideTabbar = true
                mapController.listActivitiesFilter = listActMap
                //mapController.typeCallController = "ALL"
            }
        }else if segue.identifier == "goFavDetailActivity" {
            if let detailActivity = segue.destination as? DetailActivityViewController{
                if appDelegate.itemParkSelected.code == "XV" {
                    detailActivity.isCallToMap = true
                    detailActivity.isCallbtnAllActivities = true
                }
                detailActivity.itemActivity = activitySelected
            }
        }
    }
}

extension FavoriteViewController : UITableViewDelegate, UITableViewDataSource, UpdateTableDelegate, GoRouteMapDelegate{
    func goToMap(activity: ItemActivity) {
        /*SF*/
        let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_showLocation": true]
        (AppDelegate.getKruxTracker()).trackPageView("Favorites", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        listActMap = [activity]
        performSegue(withIdentifier: "goFavMap", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listItemSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("section \(section)")
        return self.listItemSection[section].totalElements
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemSection = self.listItemSection[indexPath.section]
        switch itemSection.type {
        case "ACT":
            if appDelegate.itemParkSelected.code == "XS" || appDelegate.itemParkSelected.code == "XF" || appDelegate.itemParkSelected.code == "XP"{
                let cell : ItemActSimpleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellSimple", for: indexPath) as! ItemActSimpleTableViewCell
                let indexList = indexPath.row
                let itemActivity = listActFavorites[indexList]
                cell.setInformation(itemActivity: itemActivity, sectionFav: false)
                return cell
            }else{
                let cell : ItemActHorizontalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActHorizontalTableViewCell
                let indexList = indexPath.row
                let itemActivity = listActFavorites[indexList]
                cell.contentID = TagsContentAnalytics.Favorite.rawValue
                cell.delegate = self
                cell.delegateMap = self
                cell.setInformation(itemActivity: itemActivity, sectionFav: true)
                return cell
            }
        case "TITLE":
            let cell : ItemTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as! ItemTitleTableViewCell
            cell.lblTitle.text = "lbl_my_favorites".getNameLabel()//"lblMyFavorites".localized()
            cell.configDarkModeCustom()
            return cell
        default:
            let cell : EmptyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellEmpty", for: indexPath) as! EmptyTableViewCell
            cell.setInformation(type: .favorite)
            //cell.lblTitleSection.text = "lblMyFavorites".localized()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let itemSection = self.listItemSection[indexPath.section]
        if itemSection.type == "ACT"{
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let itemSection = self.listItemSection[indexPath.section]
        if itemSection.type == "ACT"{
            if (editingStyle == .delete) {
                //Removemos de Firebase los favoritos
                AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Favorite.rawValue, title: TagsID.delete.rawValue)
                let itemAct = listActFavorites[indexPath.row]
                LoadingView.shared.showActivityIndicator(uiView: self.view)
                FirebaseDB.shared.removeFavorite(fav: itemAct.uid, name: itemAct.nameES) { (success) in
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    if success {
                        /*SF*/
                        let pageAttr = ["\(self.appDelegate.itemParkSelected.code.uppercased())_delete": true]
                        (AppDelegate.getKruxTracker()).trackPageView("Favorites", pageAttributes:pageAttr, userAttributes:nil)
                        /**/
                        if let index = self.appDelegate.listFavoritesByPark.firstIndex(where: {$0.uid == itemAct.uid}){
                            self.appDelegate.listFavoritesByPark.remove(at: index)
                            self.listActFavorites.remove(at: indexPath.row)
                            self.listItemSection[indexPath.section].totalElements = self.listActFavorites.count
                            //let indexPathTable = IndexPath(row: indexPath.row, section: indexPath.section)
                            //tableView.deleteRows(at: [indexPath], with: .fade)
                            tableView.beginUpdates()
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            tableView.endUpdates()
                            if self.listActFavorites.count == 0 {
                                self.setSectionsTable()
                                //self.tblFavorites.reloadData()
                                //self.btnMap.isHidden = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemSection = self.listItemSection[indexPath.section]
        if itemSection.type == "ACT"{
            self.activitySelected = listActFavorites[indexPath.row]
            self.performSegue(withIdentifier: "goFavDetailActivity", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func reloadTblView() {
        print("Recarga Pagina")
    }
}
