//
//  DetailBasicViewController.swift
//  XCARET!
//
//  Created by Jacobo Díaz on 28/12/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly



class DetailBasicViewController: UIViewController, SilentScrollable {
    var itemEventSelected = ItemEvents()
    var headerView : DetailParkHeaderView!
    var silentScrolly: SilentScrolly?
    private let tableHeaderViewHeight: CGFloat = (UIScreen.main.bounds.height/1.8)
    private let tableHeaderViewCutaway: CGFloat = 0
    @IBOutlet weak var tblDetail: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationItem.leftItemsSupplementBackButton = true
       self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "btn_back".getNameLabel()/*"lblBack".localized()*/, style: .plain, target: self, action: nil)
//       self.btnAllActivities.isHidden = isCallbtnAllActivities
       self.tblDetail.estimatedRowHeight = UITableView.automaticDimension
       self.tblDetail.showsVerticalScrollIndicator = false
       self.tblDetail.dataSource = self
       self.tblDetail.delegate = self
       self.configHeaderTableView()
//       self.loadInfoView()
    }
    
    func configHeaderTableView(){
        headerView = (tblDetail.tableHeaderView as! DetailParkHeaderView)
        headerView.imageName = itemEventSelected.ev_image
        headerView.isExtra = false
        
        tblDetail.tableHeaderView = nil
        tblDetail.addSubview(headerView)
        tblDetail.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tblDetail.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
        updateHeaderView()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(tblDetail, followBottomView: tabBarController?.tabBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
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
    
    func reloadInfoActivitySelected(){
        //Recargamos Header
        headerView.imageName = itemEventSelected.ev_image
        headerView.isExtra = false
        //Recarcamos tabla
        self.tblDetail.reloadData()
//        self.scrollToFirstRow()
    }
    
    func scrollToFirstRow() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tblDetail.scrollToRow(at: indexPath, at: .top, animated: true)
        })
    }
    
    
}


extension DetailBasicViewController : UITableViewDelegate, UITableViewDataSource {
    
    func getAction(_sender: ItemDetailBasicTableViewCell) {
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.listNew.rawValue)
        self.performSegue(withIdentifier: "goModalCallCenter", sender: nil)
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cellDetailBasic", for: indexPath) as! ItemDetailBasicTableViewCell
        cell.setInformation(itemEvent: itemEventSelected)
        return cell
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

