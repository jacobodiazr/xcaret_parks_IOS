//
//  GalleryXSViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 8/7/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import FirebaseStorage

class GalleryXSViewController: UIViewController {
    let storageRef = Storage.storage().reference()
    
    @IBOutlet weak var collectionPicture: UICollectionView!
    var listGallery : [ItemPicture] = [ItemPicture]()
    var passedContentOffset = IndexPath()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadInformation()
    }
    
    override func viewDidLayoutSubviews() {
        self.collectionPicture.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
    }
    
    func loadInformation(){
        configCollectionView()
    }
    
    func configCollectionView(){
        //Configuramos layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        layout.scrollDirection = .horizontal
        
        
        if listGallery.count > 0 {
            collectionPicture.delegate = self
            collectionPicture.dataSource = self
            collectionPicture.isPagingEnabled = true
            collectionPicture.collectionViewLayout = layout
            collectionPicture.showsHorizontalScrollIndicator = false
        }
    }

    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GalleryXSViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemGallCollectionViewCell
        cell.imgView.image = UIImage(named: "Parks/XS/Activities/ThumbsNew/ok")
        
        let item = listGallery[indexPath.row]
        cell.lblName.text = ""//item.getDetail.name
        let imageRef = storageRef.child("xs/gallery")
        let fileRef = imageRef.child("\(item.photo ?? "ok").jpg")
        fileRef.downloadURL { (url, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }else{
                cell.imgView.kf.indicatorType = .activity
                cell.imgView.kf.setImage(
                    with: url,
                    placeholder : UIImage(named: "Parks/XS/Activities/ThumbsNew/ok")
                )
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
