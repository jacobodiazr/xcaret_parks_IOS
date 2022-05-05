//
//  LegalsViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 1/9/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class LegalsViewController: UIViewController {

    @IBOutlet weak var tblLegal: UITableView!
    var code: String!
    var itemLegal : ItemLegal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadInformation()
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "btn_back".getNameLabel()/*"lblBack".localized()*/, style: .plain, target: self, action: nil)
        self.title = itemLegal.getInfo.title
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setBckStatusBarStryle(type: "")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.black
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         UINavigationBar.appearance().tintColor = UIColor.white
         self.setBckStatusBarStryle(type: "clear")
    }
    
    func loadInformation(){
        FirebaseBR.shared.getLegalByCode(code: code) { (legal) in
            self.itemLegal = legal
            self.tblLegal.delegate = self
            self.tblLegal.dataSource = self
        }
    }
}

extension LegalsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = itemLegal.getInfo.desc
        return cell
    }
    
    
}
