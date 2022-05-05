//
//  viewImgViewController.swift
//  XCARET!
//
//  Created by YEiK on 20/12/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class ViewImgViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setBckStatusBarStryle(type: "clear")
        UIView.animate(withDuration: 0.5) {
            self.tabBarController?.tabBar.isHidden = true
        }
    }

}

extension ViewImgViewController: UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
            if scrollView.zoomScale > 1 {
                if let image = imageView.image {
                    let ratioW = imageView.frame.width / image.size.width
                    let ratioH = imageView.frame.height / image.size.height
                    
                    let ratio = ratioW < ratioH ? ratioW : ratioH
                    let newWidth = image.size.width * ratio
                    let newHeight = image.size.height * ratio
                    let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                    let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                    let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                    
                    let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                    
                    scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                    
                }
            } else {
                scrollView.contentInset = .zero
            }
        }
}
