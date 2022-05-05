//
//  ContentProgramsViewController.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 06/06/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class ContentProgramsViewController: UIViewController {
    var listContentProgram : [ItemContentPrograms] = [ItemContentPrograms]()
    @IBOutlet weak var btnRegresar: UIView!
    @IBOutlet weak var lblRegresar: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblContenido: UITextView!
    @IBOutlet weak var viewContentDescripcion: UIView!
    @IBOutlet weak var viewContentImageDescripcion: UIView!
    @IBOutlet weak var imageDescription: UIImageView!
    let defaults = UserDefaults.standard
    var selectItem : Int = 0
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            self.collectionView.register(UINib.init(nibName: "ContentProgramCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellContentProgram")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listContentProgram = appDelegate.listContentPrograms.filter({ $0.cont_status == 1}).sorted(by: { $0.cont_order < $1.cont_order })
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        print(appDelegate.contentPrograms.getDetail.name)
        print(appDelegate.contentPrograms.lang!)
        self.lblTitle.text = appDelegate.contentPrograms.getDetail.name
        
        print(defaults.integer(forKey: "SelectedValue"))
        selectItem = defaults.integer(forKey: "SelectedValue")
        let indexPath = IndexPath(item: defaults.integer(forKey: "SelectedValue") , section: 0)
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            self.collectionView(self.collectionView, didSelectItemAt: indexPath)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setBckStatusBarStryle(type: "clear")
        UIView.animate(withDuration: 0.5) {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
            
        }
        self.lblRegresar.text = "btn_back".getNameLabel()//"lblBack".localized()
        shadowDescripcion()
       
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(regresar))
               self.btnRegresar.addGestureRecognizer(tapRecognizer)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc public func regresar() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func shadowDescripcion (){
        
        viewContentDescripcion.dropShadow(color: UIColor.gray, opacity: 0.9, offSet: CGSize(width: -2, height: 2), radius:7, scale: true, corner: 10, backgroundColor: UIColor.clear)
    }
}


extension ContentProgramsViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listContentProgram.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellContentProgram", for: indexPath as IndexPath) as! ContentProgramCollectionViewCell
        cell.configureCell(ItemContentPrograms: listContentProgram[indexPath.row], numero: indexPath.row)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if listContentProgram.count > indexPath.row{
            
            if indexPath.row != defaults.integer(forKey: "SelectedValue"){
                defaults.set(indexPath.row, forKey: "SelectedValue")
                defaults.synchronize()
                selectItem = defaults.integer(forKey: "SelectedValue")
            }
            print(indexPath.row)
            print(selectItem)
            UIView.transition(with: self.lblTitulo,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self!.lblTitulo.text = "\(indexPath.row + 1). \(self!.listContentProgram[indexPath.row].getDetail.name)"
                                
                }, completion: nil)
            
            UIView.transition(with: self.lblContenido,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self!.lblContenido.text = self!.listContentProgram[indexPath.row].getDetail.description
                }, completion: nil)
            
            UIView.transition(with: self.imageDescription,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            
                            
                            let imagen: UIImage? = UIImage(named: "ProgramaDeMano/descriptivos/\(self!.listContentProgram[indexPath.row].cont_imagen!)")
                            if imagen != nil {
                                self!.imageDescription.image = imagen
                            }else{
                                self!.imageDescription.image = UIImage(named: "ProgramaDeMano/descriptivos/default")
                            }
            }, completion: nil)
            
            let indexPath = IndexPath(item: selectItem , section: 0)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

extension ContentProgramsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
