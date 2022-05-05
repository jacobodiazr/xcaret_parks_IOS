//
//  ItemAdmissionTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 08/07/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class ItemAdmissionTableViewCell: UITableViewCell {
    weak var detailAdmissionVC : DetailAdmissionViewController?
    @IBOutlet weak var lblTitleAdmission: UILabel!
    @IBOutlet weak var lblSloganAdmission: UILabel!
    @IBOutlet weak var lblSchedule: UILabel!
    @IBOutlet weak var lblLongDescription: UILabel!
    @IBOutlet weak var lblTitleInclude: UILabel!
    @IBOutlet weak var lblDescInclude: UILabel!
    @IBOutlet weak var viewSegmentControl: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var lblDescSegmentControl: UILabel!
    @IBOutlet weak var buttonCallCenter: UIButton!
    let buttonBar = UIView()
    var segmentSelected : Bool = true
    var colorBack = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSegmentControl.backgroundColor = colorBack
        if #available(iOS 13, *) {
            segmentControl.setOldLayout(tintColor: colorBack)
        }else{
            self.segmentControl.backgroundColor = colorBack
            self.segmentControl.tintColor = colorBack
        }
        
        self.segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: Constants.COLORS.ITEMS_CELLS.tabInactive], for: .normal)
        self.segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: Constants.COLORS.ITEMS_CELLS.tabActive], for: .selected)
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = Constants.COLORS.ITEMS_CELLS.tabActiveOutline
        viewSegmentControl.addSubview(buttonBar)
        
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: segmentControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentControl.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 1 / CGFloat(segmentControl.numberOfSegments)).isActive = true
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
    }

    func setInfoView(itemLangAdmission: ItemLanguageAdmission){
        segmentControl.setTitle("lbl_include_2".getNameLabel(), forSegmentAt: 0)
        segmentControl.setTitle("lbl_recommendations".getNameLabel(), forSegmentAt: 1)
        if self.segmentSelected{
            lblDescSegmentControl.text = itemLangAdmission.include
        }else{
            lblDescSegmentControl.text = itemLangAdmission.recomendations
        }
        self.lblTitleAdmission.text = itemLangAdmission.name
        self.lblSloganAdmission.text = itemLangAdmission.slogan
        self.lblSchedule.text = itemLangAdmission.duration
        self.lblLongDescription.text = itemLangAdmission.longDescription
        self.lblTitleInclude.text = "Informacion"
        self.lblDescInclude.text = itemLangAdmission.information
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.segmentControl.frame.width / CGFloat(self.segmentControl.numberOfSegments)) * CGFloat(self.segmentControl.selectedSegmentIndex)
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            segmentSelected = true
        default:
            segmentSelected = false
        }
        
        self.detailAdmissionVC?.updateTable(segmentSelected: self.segmentSelected)
    }
}
