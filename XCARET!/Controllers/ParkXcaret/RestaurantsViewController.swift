//
//  RestaurantsViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 1/14/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly

class RestaurantsViewController: UIViewController, SilentScrollable {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var listActivities : [ItemActivity] = [ItemActivity]()
    private let tableHeaderViewHeight: CGFloat = UIDevice().getHeightHeader()
    private let tableHeaderViewCutaway: CGFloat = 0
    var headerView : MainHeaderView!
    var silentScrolly: SilentScrolly?
    var activitySelected = ItemActivity()
    var listRestToMap : [ItemActivity] = [ItemActivity]()
    
    @IBOutlet weak var tblRestaurants: UITableView! {
        didSet{
            tblRestaurants.register(UINib(nibName: "ItemActHorizontalTableViewCell", bundle: nil), forCellReuseIdentifier: "cellActivity")
            tblRestaurants.register(UINib(nibName: "ItemTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "cellTitle")
        }
    }
    
    
    @IBAction func btnGoMap(_ sender: UIButton) {
        self.listRestToMap = self.listActivities
        self.performSegue(withIdentifier: "goRestToMap", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "btn_back".getNameLabel()/*"lblBack".localized()*/, style: .plain, target: self, action: nil)
        
        self.tblRestaurants.estimatedRowHeight = UITableView.automaticDimension
        self.tblRestaurants.showsVerticalScrollIndicator = false
        self.configHeaderTableView()
        self.getRestaurants()
    }
    
    func configHeaderTableView(){
        headerView = (tblRestaurants.tableHeaderView as! MainHeaderView)
        //headerView.typeView = ""
        tblRestaurants.tableHeaderView = nil
        tblRestaurants.addSubview(headerView)
        tblRestaurants.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tblRestaurants.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
        updateHeaderView()
    }
    
    func getRestaurants(){
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseBR.shared.getRestaurants { (listRestaurants) in
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            if listRestaurants.count > 0 {
                self.listActivities = listRestaurants
                self.tblRestaurants.delegate = self
                self.tblRestaurants.dataSource = self
            }
        }
    }
    
    
    func updateHeaderView()
    {
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tblRestaurants.bounds.width, height: tableHeaderViewHeight)
        
        if tblRestaurants.contentOffset.y < -effectiveHeight {
            self.setBckStatusBarStryle(type: "clear")
            headerRect.origin.y = tblRestaurants.contentOffset.y
            headerRect.size.height = -tblRestaurants.contentOffset.y + tableHeaderViewCutaway/2
        }else{
            self.setBckStatusBarStryle(type: "")
        }
        
        headerView.frame = headerRect
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(tblRestaurants, followBottomView: tabBarController?.tabBar)
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
        if segue.identifier == "goRestDetailAct" {
            if let detailActivity = segue.destination as? DetailActivityViewController{
                detailActivity.itemActivity = activitySelected
            }
        } else if segue.identifier == "goRestToMap"{
            if let mapController = segue.destination as? MapViewController{
                mapController.hideTabbar = true
                mapController.listActivitiesFilter = listRestToMap
            }
        }
    }
}

extension RestaurantsViewController : UITableViewDelegate, UITableViewDataSource, GoRouteMapDelegate{
    func goToMap(activity: ItemActivity) {
        self.listRestToMap = [activity]
        self.performSegue(withIdentifier: "goRestToMap", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listActivities.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell : ItemTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath) as! ItemTitleTableViewCell
            cell.lblTitle.text = "lbl_restaurants".getNameLabel()//"lblTitleRestaurants".localized()
            return cell
        }else{
            let cell : ItemActHorizontalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActHorizontalTableViewCell
            let indexList = indexPath.row - 1
            let itemActivity = listActivities[indexList]
            cell.contentID = TagsContentAnalytics.Restaurant.rawValue
            cell.setInformation(itemActivity: itemActivity, sectionFav: false)
            cell.delegateMap = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            self.activitySelected = listActivities[indexPath.row - 1]
            self.performSegue(withIdentifier: "goRestDetailAct", sender: nil)
        }
        
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
