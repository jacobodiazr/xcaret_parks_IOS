//
//  segmentRecomendationsTableViewCell.swift
//  XCARET!
//
//  Created by Jacobo Díaz on 08/01/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class segmentRecomendationsTableViewCell: UITableViewCell {

    @IBOutlet weak var segmentRecomendations: UISegmentedControl!
    @IBOutlet weak var viewSegmentControl: UIView!
    @IBOutlet weak var textViewDescriptionSegment: UITextView!
    var serlectionIndex = true
    //    @IBOutlet weak var lblDescriptionSegment: UILabel!
    var recomendations = ItemPark()
    let buttonBar = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 13, *) {
            segmentRecomendations.setOldLayout(tintColor: .white)
        }else{
            self.segmentRecomendations.backgroundColor = .white
            self.segmentRecomendations.tintColor = .white
        }
        
        self.segmentRecomendations.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: Constants.COLORS.ITEMS_CELLS.tabInactive], for: .normal)
        self.segmentRecomendations.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: Constants.COLORS.ITEMS_CELLS.tabActive], for: .selected)
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = Constants.COLORS.ITEMS_CELLS.tabActiveOutline
        viewSegmentControl.addSubview(buttonBar)
        
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: segmentRecomendations.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentRecomendations.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentRecomendations.widthAnchor, multiplier: 1 / CGFloat(segmentRecomendations.numberOfSegments)).isActive = true
        segmentRecomendations.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    func setInfoView(itemPark: ItemHome){
        segmentRecomendations.setTitle("lbl_include_2".getNameLabel()/*"lblInclude2".localized()*/, forSegmentAt: 0)
        segmentRecomendations.setTitle("lbl_recommendations".getNameLabel()/*"lblRecommendations".localized()*/, forSegmentAt: 1)
        self.recomendations = itemPark.itemPark
        textViewDescriptionSegment.text = self.recomendations.detail.include
        getContentSegment()
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.segmentRecomendations.frame.width / CGFloat(self.segmentRecomendations.numberOfSegments)) * CGFloat(self.segmentRecomendations.selectedSegmentIndex)
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            serlectionIndex = true
        default:
            serlectionIndex = false
        }
        getContentSegment()
    }
    
    func getContentSegment(){
        if serlectionIndex {
            textViewDescriptionSegment.text = self.recomendations.detail.include
            textViewDescriptionSegment.scrollRangeToVisible(NSRange(location:0, length:0))
        }else{
            textViewDescriptionSegment.text = self.recomendations.detail.recomendations
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
