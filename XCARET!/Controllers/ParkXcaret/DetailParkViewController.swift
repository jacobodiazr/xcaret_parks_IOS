//
//  DetailParkViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 11/24/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly

class DetailParkViewController: UIViewController, SilentScrollable {

    @IBOutlet weak var tblDetail: UITableView!
    private var tableHeaderViewHeight: CGFloat = 300  // CODE CHALLENGE: make this height dynamic with the height of the VC - 3/4 of the height
    private let tableHeaderViewCutaway: CGFloat = 0
    var headerView: ParkHeaderView!
    var silentScrolly: SilentScrolly?
    var keyPark : String = ""
    var itemPark : ItemPark = ItemPark()
    var segmentSelect1 = true
    var colorBack = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "btn_back".getNameLabel()/*"lblBack".localized()*/, style: .plain, target: self, action: nil)
        self.tableHeaderViewHeight = (self.view.frame.height * 0.70)
        self.tblDetail.rowHeight = UITableView.automaticDimension
        self.tblDetail.estimatedRowHeight = 100 //UITableView.automaticDimension
        self.tblDetail.showsVerticalScrollIndicator = false
        self.tblDetail.delegate = self
        self.tblDetail.dataSource = self
        self.configHeaderTableView()
        
        self.colorBack = appDelegate.itemParkSelected.code == "XF" ? Constants.COLORS.GENERAL.customDarkMode : .white
        self.tblDetail.backgroundColor = colorBack
        
    }
    
    func configHeaderTableView(){
        headerView = (tblDetail.tableHeaderView as! ParkHeaderView)
        headerView.detailParkViewController = self
        headerView.typeView = "P"
        tblDetail.tableHeaderView = nil
        tblDetail.addSubview(headerView)
        tblDetail.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        //tblDetail.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
        //updateHeaderView()
    }
    
    func updateHeaderView()
    {
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tblDetail.bounds.width, height: tableHeaderViewHeight)
        
        if tblDetail.contentOffset.y < -effectiveHeight {
            self.setBckStatusBarStryle(type: "clear")
            headerRect.origin.y = tblDetail.contentOffset.y
            headerRect.size.height = -tblDetail.contentOffset.y + tableHeaderViewCutaway/2
            headerView.frame = headerRect
        }else{
            tblDetail.sectionHeaderHeight = headerRect.size.height
            self.setBckStatusBarStryle(type: "")
        }
        
    }
    
    func showDetailPark(){
        AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainPromotions.rawValue)
        let mainNC = AppStoryboard.Promociones.instance.instantiateViewController(withIdentifier: "Prom") as! PromocionesViewController
        mainNC.modalPresentationStyle = .fullScreen
        self.present(mainNC, animated: true, completion: nil)
//        self.performSegue(withIdentifier: "goPopUpAbout", sender: nil)
//        self.performSegue(withIdentifier: "goParkBooking", sender: nil)
    }
    
    func updateTable(segmentSelected: Bool){
        segmentSelect1 = segmentSelected
        self.tblDetail.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getInfoPark()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
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
    
    func getInfoPark(){
        //FirebaseBR.shared.getInfoByPark(key: keyPark) { (park) in
            self.itemPark = appDelegate.itemParkSelected
            self.tblDetail.reloadData()
        //}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goParkBooking"{
            if let detailBooking = segue.destination as? BookingViewController{
                if appDelegate.itemCuponActive.percent > 0 {
                    detailBooking.titleWebView = "\(appDelegate.itemParkSelected.name!) - \(appDelegate.itemCuponActive.percent) %"
                }else{
                    detailBooking.titleWebView = "\(appDelegate.itemParkSelected.name!)"
                }
            }
        }else if segue.identifier == "goPopUpAbout"{
            if let popupPreBuy = segue.destination as? popUpPreBuyViewController {
                popupPreBuy.delegatePreBuyProm = self
            }
        }
    }
}

extension DetailParkViewController : UITableViewDelegate, UITableViewDataSource, ManageBuyPromDelegate{
    func sendBuyProm(itemProm: [ItemProdProm]) {
    }
    
    func sendPreBuyProm(itemProm: [ItemProdProm]) {
        self.performSegue(withIdentifier: "goParkBooking", sender: nil)
    }
    
    func sendPreBuyPromBook(){
        print("OK...")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func addCar(itemProm: [ItemProdProm]) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ItemDetailParkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as! ItemDetailParkTableViewCell
        cell.detailParkVC = self
        cell.segmentSelected = self.segmentSelect1
        cell.itemPark = itemPark
        cell.colorBack = self.colorBack
        cell.setInformation()
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
