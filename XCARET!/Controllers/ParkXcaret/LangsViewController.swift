//
//  LangsViewController.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 22/07/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit


class LangsViewController: UIViewController, UIGestureRecognizerDelegate{
    weak var delegate : ModalChangeLangHandler?
    @IBOutlet weak var widthViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heigtViewConstrainr: NSLayoutConstraint!
    @IBOutlet weak var pickerViewLangs: UIPickerView!
    var selectValue: String = ""
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSelect: UILabel!
    
    //    @IBOutlet weak var EsapcioTop: NSLayoutConstraint!
//    @IBOutlet weak var collectionView:
//        UICollectionView! {
//        didSet{
//            self.collectionView.register(UINib.init(nibName: "itemLangsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemLangsCell")
//        }
//    }
    
    let arrayLangData = appDelegate.listLanguages
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widthViewConstraint.constant = UIScreen.main.bounds.width * 0.75
        self.heigtViewConstrainr.constant = UIScreen.main.bounds.height * 0.75
        pickerViewLangs.selectRow(0, inComponent: 0, animated: true)
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))
        tap.delegate = self
        self.pickerViewLangs.addGestureRecognizer(tap)
        
        self.lblSelect.text = "lbl_select_lang".getNameLabel()
        self.setNameGuest()
        
    }
    
    func setNameGuest(){
        let provider = AppUserDefaults.value(forKey: .UserProvider, fallBackValue: "Firebase")
        if provider != "Firebase" {
            self.lblName.text = "\("lbl_hello".getNameLabel().replacingOccurrences(of: "!", with: "")) \(AppUserDefaults.value(forKey: .UserName).stringValue)!"
        }else{
            self.lblName.text = "lbl_hello".getNameLabel() //"btn_guest".getNameLabel()//"lblGuest".localized()
        }
    }
    
    @objc func pickerTapped(tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            self.dismiss(animated: true) {
            self.delegate?.changeLang(lang: self.selectValue)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    override func viewDidLayoutSubviews() {
        pickerViewLangs.subviews[1].isHidden = true
//        pickerViewLangs.subviews[1].isHidden = true
        let indice = arrayLangData.firstIndex{ $0.lang_twoLetterCode == Constants.LANG.current }
        pickerViewLangs.selectRow(indice!, inComponent: 0, animated: true)
    }
    
    
    @IBAction func btnClose(_ sender: Any) {
        //        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true) //{
//            if (self.selectValue == "es" || self.selectValue == "en"){
//                    self.delegate?.changeLang(lang: self.selectValue)
//            }
//        }
    }
}


extension LangsViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayLangData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectValue = arrayLangData[row].lang_twoLetterCode
        print(selectValue)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        let customView = UIView(frame: CGRect(x:0, y:0, width: 240, height: 40))
//        let customViewShadow = UIView(frame: CGRect(x:0, y:0, width: 240, height: 40))
        let customLabel = UILabel(frame: CGRect(x:100, y:0, width: 135, height: 40))
        
        customLabel.text = arrayLangData[row].lang_name
        let aux = arrayLangData[row]
        print(aux)
        let img = UIImageView(frame: CGRect(x:50, y:0, width: 40, height: 40))
        img.image = UIImage(named: "Icons/flags/ic_\(arrayLangData[row].lang_twoLetterCode!)")
        img.contentMode = .scaleAspectFit
        
        customView.backgroundColor = .white
        customView.layer.cornerRadius = 8
        customView.layer.masksToBounds = true;
        customView.addSubview(img)
        customView.addSubview(customLabel)
        
        return customView
    }
    
    @objc func pickerSelect(_ sender: UITapGestureRecognizer? = nil) {
        print(self.selectValue)
        self.dismiss(animated: true) {
            self.delegate?.changeLang(lang: self.selectValue)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 50
    }
    
}





//extension LangsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.arrayLangData.count
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemLangsCell", for: indexPath as IndexPath) as! itemLangsCollectionViewCell
//        cell.setData(item: self.arrayLangData[indexPath.row])
////        cell.delegate = self
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(self.arrayLangData[indexPath.row].lang_twoLetterCode!)
//        if self.arrayLangData.count > indexPath.row{
//            self.dismiss(animated: true) {
//                 self.delegate?.changeLang(lang: self.arrayLangData[indexPath.row].lang_twoLetterCode)
//            }
//        }
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width * 0.80, height: 40)
//    }
//
//}
