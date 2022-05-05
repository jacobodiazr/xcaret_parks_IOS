//
//  ItemActivityXSTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 7/31/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemActivityXSTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var viewSegmentControll: UIView!
    let buttonBar = UIView()
    private var itemActivity : ItemActivity = ItemActivity()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.segmentControl.backgroundColor = UIColor.clear
        self.segmentControl.tintColor = UIColor.clear
        self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: Constants.COLORS.ITEMS_CELLS.tabInactive], for: .normal)
        self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: Constants.COLORS.ITEMS_CELLS.tabActive], for: .selected)
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = Constants.COLORS.ITEMS_CELLS.tabActiveOutline
        viewSegmentControll.addSubview(buttonBar)
        
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: segmentControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentControl.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 1 / CGFloat(segmentControl.numberOfSegments)).isActive = true
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setInformation(item : ItemActivity){
        self.itemActivity = item
        self.lblCategory.text = item.getCategory.name
         self.lblDescription.text = item.details.description
        if !itemActivity.details.warning.isEmpty || !itemActivity.getRestrictions.isEmpty {
            if !itemActivity.details.warning.isEmpty {
                self.lblWarning.text = itemActivity.details.warning
            }
        }else{
            self.viewSegmentControll.isHidden = true
            self.lblWarning.isHidden = true
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.segmentControl.frame.width / CGFloat(self.segmentControl.numberOfSegments)) * CGFloat(self.segmentControl.selectedSegmentIndex)
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            lblWarning.text = !itemActivity.details.warning.isEmpty ? itemActivity.details.warning : "-"
        default:
            lblWarning.text = !itemActivity.getRestrictions.isEmpty ? itemActivity.getRestrictions : "-"
        }
    }

}
