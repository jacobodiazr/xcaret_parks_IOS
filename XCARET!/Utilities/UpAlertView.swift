//
//  UpAlertType.swift
//  XCARET!
//
//  Created by Angelica Can on 10/07/18.
//  Copyright © 2018 Experiencias Xcaret. All rights reserved.
//

import UIKit
import Foundation

class UpAlertView: UIView {

    private var lblMessage : UILabel!
    
    convenience init(type: AlertType, message: String) {
       let parentView: UIWindow? = UIApplication.shared.keyWindow
        
        self.init(frame: CGRect(x: 0.0, y: -90.0, width: (parentView!.frame.width), height: 90.0))
        switch type {
        case .error:
            self.backgroundColor = Constants.COLORS.MESSAGE_ALERT.error
        case .success :
            self.backgroundColor = Constants.COLORS.MESSAGE_ALERT.success
        case .warning :
            self.backgroundColor = Constants.COLORS.MESSAGE_ALERT.warning
        case .info:
            self.backgroundColor = Constants.COLORS.MESSAGE_ALERT.info
        }
        self.alpha = 0.0
        
        self.lblMessage = UILabel(frame: CGRect(x: 10.0, y: 20.0, width: self.frame.width - 20.0, height: self.frame.height - 25.0))
        self.lblMessage.text = message
        self.lblMessage.textColor = UIColor.white
        self.lblMessage.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        self.lblMessage.numberOfLines = 0
        self.lblMessage.lineBreakMode = .byWordWrapping
        self.addSubview(self.lblMessage)
        
        parentView!.addSubview(self)
        parentView!.bringSubviewToFront(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.lblMessage = nil
    }
    
    func show(completion: (() -> ())? ) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.frame.origin.y = 0
            self.layer.zPosition = 1
        }) { (completed) in
            if completed {
                sleep(3)
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame.origin.y = -60.0
                    self.alpha = 0.0
                }, completion: { (completed) in
                    if completed {
                        self.removeFromSuperview()
                    }
                    
                    completion!()
                })
            }
        }
    }

}
