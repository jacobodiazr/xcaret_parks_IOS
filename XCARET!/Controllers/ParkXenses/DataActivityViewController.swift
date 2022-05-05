//
//  DataActivityViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 7/18/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly

class DataActivityViewController: UIViewController, SilentScrollable {
    var index : Int = 0
    var itemActivity : ItemActivity = ItemActivity()
    var headerView : HeaderXensesView!
    var silentScrolly: SilentScrolly?
    private let tableHeaderViewHeight: CGFloat = (UIScreen.main.bounds.height/1.8)
    private let tableHeaderViewCutaway: CGFloat = 0
    
    @IBOutlet weak var tblActivity: UITableView! {
        didSet{
            //tblActivity.register(UINib(nibName: "ItemActHorizontalTableViewCell", bundle: nil), forCellReuseIdentifier: "cellActivity")
            tblActivity.delegate = self
            tblActivity.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Activity DidLoad-> \(itemActivity.details.name)")
        
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "btn_back".getNameLabel()/*"lblBack".localized()*/, style: .plain, target: self, action: nil)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.tblActivity.estimatedRowHeight = UITableView.automaticDimension
        self.tblActivity.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Activity willAppear-> \(itemActivity.details.name)")
        self.configHeaderTableView()
    }
    
    func configHeaderTableView(){
        if headerView == nil{
            headerView = (tblActivity.tableHeaderView as! HeaderXensesView)
            headerView.imageName = itemActivity.act_image
            headerView.heightGradient = tableHeaderViewHeight
            headerView.setInformation(item: itemActivity)
            
            headerView.dataViewController = self
            tblActivity.tableHeaderView = nil
            tblActivity.addSubview(headerView)
            tblActivity.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
            tblActivity.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
            updateHeaderView()
        }
    }
    
    
    func updateHeaderView(){
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: self.view.frame.width, height: tableHeaderViewHeight)
        
        if tblActivity.contentOffset.y < -effectiveHeight {
            self.setBckStatusBarStryle(type: "clear")
            headerRect.origin.y = tblActivity.contentOffset.y
            headerRect.size.height = -tblActivity.contentOffset.y + tableHeaderViewCutaway/2
        }else{
            self.setBckStatusBarStryle(type: "")
        }
        
        headerView.frame = headerRect
    }
    
    func openGalleryActivity(gallery: [ItemPicture]){
        print("Galería: \(gallery.count)")
        self.performSegue(withIdentifier: "goGalleryXS", sender: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(tblActivity, followBottomView: tabBarController?.tabBar)
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
        if segue.identifier == "goGalleryXS" {
            if let galleryController = segue.destination as? GalleryXSViewController{
                galleryController.listGallery = self.itemActivity.gallery
            }
        }
    }
}

extension DataActivityViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell  = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActivityXSTableViewCell
        cell.setInformation(item: itemActivity)
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
