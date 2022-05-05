//
//  AllViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 1/31/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly

class AllViewController: UIViewController, SilentScrollable {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var listActivities : [ItemActivity] = [ItemActivity]()
    private let tableHeaderViewHeight: CGFloat = UIDevice().getHeightHeader()
    private let tableHeaderViewCutaway: CGFloat = 0
    var headerView : MainHeaderView!
    var silentScrolly: SilentScrolly?
    var itemActivitySelected : ItemActivity = ItemActivity()


    @IBOutlet weak var tblActivities: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "btn_back".getNameLabel()/*"lblBack".localized()*/, style: .plain, target: self, action: nil)
        // Do any additional setup after loading the view.
        
        self.tblActivities.estimatedRowHeight = 100
        self.tblActivities.rowHeight = UITableView.automaticDimension
        self.tblActivities.showsVerticalScrollIndicator = false
        self.configHeaderTableView()
        self.loadInfo()
    }
    
    func loadInfo(){
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        self.listActivities = appDelegate.listActivitiesByPark
        if listActivities.count > 0 {
            tblActivities.delegate = self
            tblActivities.dataSource = self
        }
        LoadingView.shared.hideActivityIndicator(uiView: self.view)
    }
    
    func configHeaderTableView(){
        headerView = (tblActivities.tableHeaderView as! MainHeaderView)
        //headerView.lblName.text =  "lblAllActivities".localized()
        tblActivities.tableHeaderView = nil
        tblActivities.addSubview(headerView)
        tblActivities.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tblActivities.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
        updateHeaderView()
    }
    
    func updateHeaderView()
    {
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tblActivities.bounds.width, height: tableHeaderViewHeight)
        
        if tblActivities.contentOffset.y < -effectiveHeight {
            self.setBckStatusBarStryle(type: "clear")
            headerRect.origin.y = tblActivities.contentOffset.y
            headerRect.size.height = -tblActivities.contentOffset.y + tableHeaderViewCutaway/2
        }else{
            self.setBckStatusBarStryle(type: "")
        }
        
        headerView.frame = headerRect
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblActivities.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(tblActivities, followBottomView: tabBarController?.tabBar)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goAllDetailAct" {
            if let detailActivity = segue.destination as? DetailActivityViewController{
                detailActivity.itemActivity = itemActivitySelected
            }
        }else if segue.identifier == "goActXenses"{
            if let detailXenses = segue.destination as? ManagePageViewController {
                detailXenses.currentViewControllerIndex = 0
                detailXenses.dataSource = [itemActivitySelected]
            }
        }
    }
}

extension AllViewController : UITableViewDelegate, UITableViewDataSource, ChangeHeightTableView, GoDetailActDelegate {
    func gotoDetail(activity: ItemActivity) {
        print("detalle Actividad")
        itemActivitySelected = activity
        if appDelegate.itemParkSelected.code == "XS"{
            self.performSegue(withIdentifier: "goActXenses", sender: nil)
        }else{
            self.performSegue(withIdentifier: "goAllDetailAct", sender: nil)
        }
    }
    
    func changeHeightRow(newHeight: CGFloat) {
        print("New Heigh \(newHeight)")
        tblActivities.rowHeight = newHeight
        tblActivities.beginUpdates()
        tblActivities.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCollection", for: indexPath) as! ItemAllTableViewCell
        cell.setInfoView(listActivities: self.listActivities)
        cell.delegateAct = self
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
    
    
}
