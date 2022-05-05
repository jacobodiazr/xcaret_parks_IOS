//
//  SideMapView.swift
//  XCARET!
//
//  Created by Angelica Can on 1/4/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
//import CollapsibleTableSectionViewController

class SideMapView: UIView {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var viewBackground : UIView!
    var viewMenu : UIView!
    var tableView : UITableView!
    var btnClose : UIButton!
    
    var viewHeaderTable : UIView!
    var isVisible : Bool!
    var listFilter : [ItemFilterMap]!
    
    weak var mapViewController : MapViewController?
    var expandedSectionHeaderNumber: Int = -1
    let kHeaderSectionTag: Int = 6900
    var colorsHeaderTable : [UIColor]!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        //Boton ocultar vista
        self.btnClose = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.btnClose.addTarget(self, action: #selector(prueba(_:)) , for: UIControl.Event.touchUpInside)
        
        //Vista que contiene el menu
        self.viewMenu = UIView(frame: CGRect(x: 100, y: self.frame.origin.y, width: UIScreen.main.bounds.size.width - 100, height: UIScreen.main.bounds.size.height))
        self.viewMenu.roundCorners(corners: [.topLeft, .bottomLeft ], radius: 30)
        self.viewMenu.shadowColor = UIColor.black.withAlphaComponent(0.60)
        self.viewMenu.shadowRadius = 30
        self.viewMenu.shadowOffset = CGSize(width: 10, height: 0)
    
        //Vista que contiene el header
        if appDelegate.itemParkSelected.code == "XC"{
            self.colorsHeaderTable = [Constants.COLORS.ITEMS_CELLS.bgSideMenuXCA, Constants.COLORS.ITEMS_CELLS.bgSideMenuXCB]
        }else{
            self.colorsHeaderTable = [Constants.COLORS.ITEMS_CELLS.bgSideMenuXHA, Constants.COLORS.ITEMS_CELLS.bgSideMenuXHB]
        }
        self.viewHeaderTable = UIView(frame: CGRect(x: 0, y: 0, width: self.viewMenu.frame.width, height: 80))
        self.viewHeaderTable.applyGradient(colours: colorsHeaderTable
            , cornerRadius: 0
            , direction: .horizontal)
        let buttonClose = ButtonWithImage()
        buttonClose.frame = CGRect(x:  self.viewHeaderTable.frame.width - 150, y: 25, width: 140, height: 30)
        buttonClose.setTitle("lbl_close".getNameLabel()/*"lblClose".localized()*/, for: .normal)
        buttonClose.setImage(UIImage(named: "Icons/ic_cerrar"), for: .normal)
        buttonClose.imageView?.contentMode = .scaleAspectFit
        buttonClose.addTarget(self, action: #selector(prueba(_:)) , for: UIControl.Event.touchUpInside)
        self.viewHeaderTable.addSubview(buttonClose)
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: self.viewHeaderTable.frame.height, width: self.viewMenu.frame.width, height: self.viewMenu.frame.height - self.viewHeaderTable.frame.height))
        self.tableView.backgroundColor = UIColor.white
        
        
        
        self.listFilter = appDelegate.listFilterMapByPark
        self.tableView.register(UINib(nibName: "ItemMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.register(UINib(nibName: "ItemSideHeaderCell", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "ItemSideHeaderCell")
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.viewMenu.addSubview(self.viewHeaderTable)
        self.viewMenu.addSubview(self.tableView)
        self.addSubview(self.btnClose)
        self.addSubview(self.viewMenu)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizer.Direction.right {
            self.showhideSlide()
        }
    }
    
    @objc func prueba(_ sender: UIButton){
        self.showhideSlide()
    }
    
    @objc func pruebas(_ sender: UIButton){
        print("Entra a pruebas")
        self.showhideSlide()
    }
    
    @objc func showhideSlide(){
        UIView.animate(withDuration: 0.75, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.frame.origin.x = self.frame.origin.x > 0 ? 0 : UIScreen.main.bounds.size.width
        }) { (success) in
            
        }
    }
}

extension SideMapView : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if listFilter.count > 0 {
            return listFilter.count
        }else{
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewMenu.bounds.size.width, height: viewMenu.bounds.size.height))
            messageLabel.text = "lbl_retrieving".getNameLabel()//"lblRetrieving".localized()
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section){
            let arraySubmenu = self.listFilter[section].subFilter
            return (arraySubmenu?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ItemSideHeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ItemSideHeaderCell") as! ItemSideHeaderCell
        headerView.setInfoCell(itemFilter: listFilter[section], tag: kHeaderSectionTag, section: section)
        headerView.tag = section
        print(listFilter[section].getDetail.name)
        
        if let viewWithTag = self.viewMenu.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        
        if listFilter[section].subFilter.count > 0 {
            let headerFrame = self.viewMenu.frame.size
            let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 45, y: 20, width: 20, height: 20));
            theImageView.image = UIImage(named: "Icons/ico_dropdown")
            theImageView.tag = kHeaderSectionTag + section
            headerView.addSubview(theImageView)
        }
        
        //Añadimos gesto para seleccionar el item
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(self.sectionHeaderWasTouched(_:)))
        headerView.addGestureRecognizer(headerTapGesture)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemMenuTableViewCell
        let item = listFilter[indexPath.section]
        cell.setInfoView(itemFilter: item.subFilter[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listFilter[indexPath.section]
        //Ocultamos el slide y filtramos en el mapa
        //let headerView = tableView.viewWithTag(indexPath.section) as! ItemSideHeaderCell //UITableViewHeaderFooterView
        let headerView = tableView.headerView(forSection: indexPath.section) as! ItemSideHeaderCell
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        if (self.expandedSectionHeaderNumber == section) {
            tableViewCollapeSection(section, imageView: eImageView!)
        }
        self.showhideSlide()
        self.mapViewController?.filterResults(type: item.typeEntity, code: item.f_code, subfilter: item.subFilter[indexPath.row].sf_code )
    }
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! ItemSideHeaderCell //UITableViewHeaderFooterView
        let section    = headerView.tag
        
        print("tag header: \(section)")
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if listFilter[section].subFilter.count > 0 {
            if (self.expandedSectionHeaderNumber == -1) {
                self.expandedSectionHeaderNumber = section
                tableViewExpandSection(section, imageView: eImageView!)
            } else {
                if (self.expandedSectionHeaderNumber == section) {
                    tableViewCollapeSection(section, imageView: eImageView!)
                } else {
                    let cImageView = self.viewMenu.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                    tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                    tableViewExpandSection(section, imageView: eImageView!)
                }
            }
        }else{
            self.showhideSlide()
            self.mapViewController?.filterResults(type: listFilter[section].typeEntity, code: listFilter[section].f_code, subfilter: "")
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.listFilter[section].subFilter
        
        self.expandedSectionHeaderNumber = -1
        if (sectionData!.count == 0) {
            return
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData!.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: true)
            self.tableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.listFilter[section].subFilter
        
        if (sectionData!.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData!.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
}
