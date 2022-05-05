//
//  DetailActivityViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 12/20/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly

class DetailActivityViewController: UIViewController, SilentScrollable {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var itemActivity : ItemActivity!
    private let tableHeaderViewHeight: CGFloat = (UIScreen.main.bounds.height/1.8)
    private let tableHeaderViewCutaway: CGFloat = 0
    var headerView : DetailParkHeaderView!
    var silentScrolly: SilentScrolly?
    var itemHome : ItemHome = ItemHome()
    var isCallToMap : Bool = false
    var isCallbtnAllActivities : Bool = false
    var listActivitiesMap = [ItemActivity]()
    var isreload : Bool = false
    @IBOutlet weak var btnAllActivities: UIButton!
    
    @IBOutlet weak var tblDetail: UITableView! {
        didSet{
            tblDetail.register(UINib(nibName: "ItemActTableViewCell", bundle: nil), forCellReuseIdentifier: "cellActivity")
            tblDetail.register(UINib(nibName: "ItemActExtraTableViewCell", bundle: nil), forCellReuseIdentifier: "cellActExtra")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "btn_back".getNameLabel()/*"lblBack".localized()*/, style: .plain, target: self, action: nil)
        self.btnAllActivities.isHidden = isCallbtnAllActivities
        
        self.tblDetail.estimatedRowHeight = UITableView.automaticDimension
        self.tblDetail.showsVerticalScrollIndicator = false
        self.configHeaderTableView()
        self.loadInfoView()
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.TopActivities.rawValue, title: itemActivity.nameES)
        
        
        let colorBack = appDelegate.itemParkSelected.code == "XF" ? Constants.COLORS.GENERAL.customDarkMode : .white
        tblDetail.backgroundColor = colorBack
    }
    
    @IBAction func btnAllActivities(_ sender: UIButton) {
        self.listActivitiesMap = [ItemActivity]()
        performSegue(withIdentifier: "goDetailActMap", sender: nil)
    }
    
    func configHeaderTableView(){
        headerView = (tblDetail.tableHeaderView as! DetailParkHeaderView)
        headerView.imageName = itemActivity.act_image
        headerView.isExtra = itemActivity.act_extra
        
        //headerView.image = imageName
        
        tblDetail.tableHeaderView = nil
        tblDetail.addSubview(headerView)
        tblDetail.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tblDetail.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
        updateHeaderView()
    }
    
    func loadInfoView(){
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseBR.shared.getActivitiesByCategory(activity: itemActivity) { (itemDetailAct) in
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            self.itemHome = itemDetailAct
            if !self.isreload {
                self.tblDetail.delegate = self
                self.tblDetail.dataSource = self
            }else{
                DispatchQueue.main.async {
                    self.reloadInfoActivitySelected()
                }
            }
        }
    }
    
    func reloadInfoActivitySelected(){
        //Recargamos Header
        headerView.imageName = itemActivity.act_image
        headerView.isExtra = itemActivity.act_extra
        
        //Recarcamos tabla
        self.tblDetail.reloadData()
        self.scrollToFirstRow()
    }
    
    func scrollToFirstRow() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tblDetail.scrollToRow(at: indexPath, at: .top, animated: true)
        })
    }
    
    func updateHeaderView(){
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: self.view.frame.width, height: tableHeaderViewHeight)
        
        if tblDetail.contentOffset.y < -effectiveHeight {
            self.setBckStatusBarStryle(type: "clear")
            headerRect.origin.y = tblDetail.contentOffset.y
            headerRect.size.height = -tblDetail.contentOffset.y + tableHeaderViewCutaway/2
        }else{
            self.setBckStatusBarStryle(type: "")
        }
        
        headerView.frame = headerRect
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        reloadInfoActivitySelected()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(tblDetail, followBottomView: tabBarController?.tabBar)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailActMap" {
            if let mapController = segue.destination as? MapViewController {
                mapController.hideTabbar = true
                mapController.listActivitiesFilter = self.listActivitiesMap
            }
        }
    }
}

extension DetailActivityViewController : UITableViewDelegate, UITableViewDataSource, ManageControllersDelegate, GoRouteMapDelegate {
    func sendDetailAdmission(admission: ItemAdmission) {
        print("")
    }
    
    func sendDetailActivity(activity: ItemActivity, idEvent: String) {
        if itemActivity.uid != activity.uid{
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.ActivityDetail.rawValue, title: TagsID.listMore.rawValue)
            self.itemActivity = activity
            self.isreload = true
            self.loadInfoView()
            print("Recargar pagina")
        }
    }
    
    func sendDetailActivity(activity: ItemXOStaticData, idEvent: String) {
//        if itemActivity.uid != activity.uid{
//            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.ActivityDetail.rawValue, title: TagsID.listMore.rawValue)
//            self.itemActivity = activity
//            self.isreload = true
//            self.loadInfoView()
//            print("Recargar pagina")
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appDelegate.itemParkSelected.code == "XV"
            || appDelegate.itemParkSelected.code == "XF"
            || appDelegate.itemParkSelected.code == "XP"
            || appDelegate.itemParkSelected.code == "XA"
            || appDelegate.itemParkSelected.code == "FE"{
            return 1
        }else{
            return itemHome.listActivities.count > 0 ? 2 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as! ItemDetailActivityTableViewCell
            cell.delegate = self
            cell.setInformation(itemActivity: itemActivity, isReload: isreload)
            cell.btnGo.isHidden = isCallToMap
            return cell
        }else {
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            
            if itemActivity.category.cat_code == "REST"{
                itemHome.name = String(format: "lblTitleSubcategory".localized(), itemActivity.getSubcategory.name)
            }else{
                itemHome.name = String(format: "lblTitleSubcategory".localized(), itemActivity.getCategory.name)
            }
            
            cell.collectionView.tag = 112
            cell.setInfoView(itemHome: itemHome)
            cell.delegate = self
            return cell
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
    
//    func sendDetailActivity(activity: ItemActivity) {
//        if itemActivity.uid != activity.uid{
//            self.itemActivity = activity
//            self.isreload = true
//            self.loadInfoView()
//            print("Recargar pagina")
//        }
//    }
    
    func goToMap(activity: ItemActivity) {
        self.listActivitiesMap = [activity]
        performSegue(withIdentifier: "goDetailActMap", sender: nil)
    }
}
