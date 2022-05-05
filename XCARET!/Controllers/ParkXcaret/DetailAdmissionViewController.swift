//
//  DetailAdmissionViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 08/07/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly

class DetailAdmissionViewController: UIViewController, SilentScrollable{
    var itemAdmission = ItemAdmission()
    private var tableHeaderViewHeight: CGFloat = (UIScreen.main.bounds.height/1.8)
    private let tableHeaderViewCutaway: CGFloat = 0
    var headerView: AdmissionHeaderView!
    var silentScrolly: SilentScrolly?
    var colorBack = UIColor()
    var segmentSelect1 = true
    
    @IBOutlet weak var tblDetail: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "btn_back".getNameLabel(), style: .plain, target: self, action: nil)
        self.tableHeaderViewHeight = (self.view.frame.height * 0.70)
        self.tblDetail.rowHeight = UITableView.automaticDimension
        self.tblDetail.estimatedRowHeight = UITableView.automaticDimension
        self.tblDetail.showsVerticalScrollIndicator = false
        self.tblDetail.dataSource = self
        self.tblDetail.delegate = self
        self.configHeaderTableView()
        self.colorBack = appDelegate.itemParkSelected.code == "XF" ? Constants.COLORS.GENERAL.customDarkMode : .white
        self.tblDetail.backgroundColor = colorBack
    }
    
    func configHeaderTableView(){
        headerView = (tblDetail.tableHeaderView as! AdmissionHeaderView)
        headerView.imageName = itemAdmission.ad_image
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
    
    func updateTable(segmentSelected: Bool){
        segmentSelect1 = segmentSelected
        self.tblDetail.reloadData()
    }
}

extension DetailAdmissionViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAdmission", for: indexPath) as! ItemAdmissionTableViewCell
        cell.detailAdmissionVC = self
        cell.segmentSelected = self.segmentSelect1
        cell.setInfoView(itemLangAdmission: itemAdmission.getDetail)
        return cell
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
