//
//  StackMainViews.swift
//  XCARET!
//
//  Created by Angelica Can on 6/27/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class StackMainViews: UIView {
    private var imageView : UIImageView!
    private var textView : UITextView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .blue
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 80))
        self.imageView.image = UIImage(named: "Logos/logoXC")
        self.textView = UITextView(frame: CGRect(x: self.imageView.frame.height + 5 , y: 0, width: self.frame.width, height: 20))
        self.textView.text = "Prueba"
        
        self.addSubview(imageView)
        self.addSubview(textView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
