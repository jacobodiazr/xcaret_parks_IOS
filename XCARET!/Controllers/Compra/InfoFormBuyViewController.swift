//
//  InfoFormBuyViewController.swift
//  XCARET!
//
//  Created by YEiK on 11/05/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class InfoFormBuyViewController: UIViewController {
    
    weak var delegateDataFormBuy: DataFormBuy?
    
    @IBOutlet weak var filtro: UISearchBar!
    @IBOutlet weak var filtroConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableFiltro: UITableView!
    @IBOutlet weak var contentDataView: UIView!
    @IBOutlet weak var contentDataConstraint: NSLayoutConstraint!
    
    var idDataPopUp = ""
    var sizeScreem = UIScreen.main.bounds.height
    var itemSelectDataTitleUser = [ItemLangTitle]()
    var itemSelectDataPaisUser = [ItemLangCountry]()
    var itemsDataStates = [ItemStates]()
    var itemsDataStatesAUX = [ItemStates]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtro.delegate = self
        tableFiltro.delegate = self
        tableFiltro.dataSource = self
        contentDataConstraint.constant = sizeScreem * 0.80
        if idDataPopUp == "titleUser" || idDataPopUp == "titleUserVisitante" {
            itemSelectDataTitleUser = appDelegate.listItemLangTitle.filter({$0.langCode == Constants.LANG.current.lowercased() && $0.enabled == 1})
            filtro.isHidden = true
            filtroConstraint.constant = 15
            contentDataConstraint.constant = (CGFloat(itemSelectDataTitleUser.count) * 44.0) + 30.0
        }else if idDataPopUp == "paisUser" || idDataPopUp == "paisUserVisitante" {
            itemSelectDataPaisUser = appDelegate.listItemLangCountry.filter({$0.lang == Constants.LANG.current.lowercased()})
        }else if idDataPopUp == "estadoUser" || idDataPopUp == "estadoUserVisitante" {
            itemsDataStatesAUX = itemsDataStates
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if idDataPopUp == "titleUser" || idDataPopUp == "titleUserVisitante"{
            if searchText.isEmpty {
                itemSelectDataTitleUser = appDelegate.listItemLangTitle.filter({$0.langCode == Constants.LANG.current.lowercased() && $0.enabled == 1})
            }else{
                itemSelectDataTitleUser = appDelegate.listItemLangTitle.filter({$0.name.contains(searchText)})
            }
            
        }else if idDataPopUp == "paisUser" || idDataPopUp == "paisUserVisitante" {
            if searchText.isEmpty {
                itemSelectDataPaisUser = appDelegate.listItemLangCountry.filter({$0.lang == Constants.LANG.current.lowercased()})
            }else{
                itemSelectDataPaisUser = appDelegate.listItemLangCountry.filter({$0.name.contains(searchText)})
            }
        }else if idDataPopUp == "estadoUser" || idDataPopUp == "estadoUserVisitante" {
            if searchText.isEmpty {
                itemsDataStatesAUX = itemsDataStates
            }else{
                itemsDataStatesAUX = itemsDataStates.filter({$0.name.contains(searchText)})
            }
            
        }
        tableFiltro.reloadData()
    }
}


extension InfoFormBuyViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var itemsCount = 0
        if idDataPopUp == "titleUser" || idDataPopUp == "titleUserVisitante"{
            itemsCount = itemSelectDataTitleUser.count
        }else if idDataPopUp == "paisUser" || idDataPopUp == "paisUserVisitante" {
            itemsCount = itemSelectDataPaisUser.count
        }else if idDataPopUp == "estadoUser" || idDataPopUp == "estadoUserVisitante" {
            itemsCount = itemsDataStatesAUX.count
        }
        return itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let colorLabel = UIColor(red: 127/255, green: 139/255, blue: 159/255, alpha: 1.0)
        
        if idDataPopUp == "titleUser" || idDataPopUp == "titleUserVisitante"{
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            cell.textLabel!.text = itemSelectDataTitleUser[indexPath.row].name
            cell.textLabel?.textColor = colorLabel
            cell.backgroundColor = .clear
            return cell
        }else if idDataPopUp == "paisUser" || idDataPopUp == "paisUserVisitante" {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            cell.textLabel!.text = itemSelectDataPaisUser[indexPath.row].name
            cell.textLabel?.textColor = colorLabel
            return cell
        }else if idDataPopUp == "estadoUser" || idDataPopUp == "estadoUserVisitante" {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            cell.textLabel!.text = itemsDataStatesAUX[indexPath.row].name
            cell.textLabel?.textColor = colorLabel
            return cell
        }else{
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            cell.textLabel!.text = ""
            cell.textLabel?.textColor = colorLabel
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if idDataPopUp == "titleUser" || idDataPopUp == "titleUserVisitante"{
            delegateDataFormBuy?.dataFormBuyTitle(title: idDataPopUp, itemTitle: itemSelectDataTitleUser[indexPath.row])
        }else if idDataPopUp == "paisUser" || idDataPopUp == "paisUserVisitante" {
            delegateDataFormBuy?.dataFormBuyPais(pais: idDataPopUp, itemPais: itemSelectDataPaisUser[indexPath.row])
        }else if idDataPopUp == "estadoUser" || idDataPopUp == "estadoUserVisitante" {
            delegateDataFormBuy?.dataFormBuyEstado(estado: idDataPopUp, itemEstado: itemsDataStatesAUX[indexPath.row])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
