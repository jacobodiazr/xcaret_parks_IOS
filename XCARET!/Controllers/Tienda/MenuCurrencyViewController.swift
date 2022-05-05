//
//  MenuCurrencyViewController.swift
//  XCARET!
//
//  Created by YEiK on 04/10/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class MenuCurrencyViewController: UIViewController {
    weak var delegateChangeCurrencyShop : ChangeCurrencyShop?
    var listCurrenciesCount = [ItemCurrencies]()
    var current: String = ""
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var currencySelectCollectionView: UICollectionView!{
        didSet{
            self.currencySelectCollectionView.register(UINib.init(nibName: "itemCurrencyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemCurrency")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencySelectCollectionView.dataSource = self
        currencySelectCollectionView.delegate = self
        
        titleLbl.text = "lbl_curreny_dialog".getNameLabel()
        
        listCurrenciesCount = appDelegate.listCurrencies
        
        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: currencySelectCollectionView.bounds.size.width, height: 50)
        floawLayout.scrollDirection = .vertical
        floawLayout.sideItemScale = 1.0
        floawLayout.sideItemAlpha = 0.4
        floawLayout.accessibilityElementsHidden = true
        floawLayout.spacingMode = .fixed(spacing: 0.0)
        currencySelectCollectionView.collectionViewLayout = floawLayout
    }
    
    @IBAction func goMenuCurrency(_ sender: Any) {
        self.dismiss(animated: true)
        if current == "" {
            current = UserDefaults.standard.string(forKey: "UserCurrency") ?? Constants.CURR.current
        }
        if  current != Constants.CURR.current {
            UserDefaults.standard.set(current, forKey: "UserCurrency")
            UserDefaults.standard.synchronize()
            Constants.CURR.current = current
            delegateChangeCurrencyShop?.changeCurrencyShop(codeCurrency: current)
        }
        
    }
    
    func setPositionActivity(index : Int){
        
        if listCurrenciesCount.count > index{
            let indexPath = IndexPath(item: index, section: 0)
            self.currencySelectCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            current = listCurrenciesCount[index].currency
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == currencySelectCollectionView) {
        let layout = self.currencySelectCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        }
    }
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            print("page at centre = \(currentPage)")
            setPositionActivity(index: currentPage)
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.currencySelectCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let indexcurrency = listCurrenciesCount.index(where: { $0.currency == Constants.CURR.current }) ?? 0//.index(after: <#T##Int#>) .firstIndex(of: Constants.CURR.current))
        let indexPath = IndexPath(item: indexcurrency, section: 0)
        DispatchQueue.main.async {
            self.currencySelectCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        }
    }
    
}




extension MenuCurrencyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCurrenciesCount.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCurrency", for: indexPath) as! itemCurrencyCollectionViewCell
        cell.configCurrency(itemCurrencies: listCurrenciesCount[indexPath.row])
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let indexPath = IndexPath(item: indexPath.row, section: 0)
        self.currencySelectCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//        UserDefaults.standard.set(listCurrenciesCount[indexPath.row].currency, forKey: "UserCurrency")
//        UserDefaults.standard.synchronize()
        current = listCurrenciesCount[indexPath.row].currency
        print(current)
        print(current)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: currencySelectCollectionView.bounds.size.width , height: 50)
    }
    
}
