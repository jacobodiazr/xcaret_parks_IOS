//
//  AlertDefaultViewController.swift
//  XCARET!
//
//  Created by YEiK on 03/11/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class AlertDefaultViewController: UIViewController {

    @IBOutlet weak var textAlert: UITextView!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widhtConstraint: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var viewContentAlert: UIView!
    
    var typeAlert = WindowAlert.allotment
    var height : Double = 230.0
    var widht : Double = 0.0
    var texto : String = "Ocurrio un error inesperado, vuelva a intenralo mas tarde"
    var textButton: String = "Default"
    var urlActionButton: String = "http://www.xcaret.com"
    var enabledButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if enabledButton {
            let position_x = (self.widht / 2) - 50
            let position_y = self.height - 70
            let button = UIButton(frame: CGRect(x: position_x, y: position_y, width: 100, height: 50))
            let colorButton = UIColor(red: 3/255, green: 129/255, blue: 255/255, alpha: 1.00)
            button.setTitle(textButton, for: .normal)
            button.setTitleColor(colorButton, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.viewContentAlert.addSubview(button)
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        if let url = URL(string: urlActionButton) {
            self.dismiss(animated: true)
            if #available(iOS 10.0, *){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func configAlert(type : WindowAlert = WindowAlert.help, heightC : Double = 0.0, widhtC : Double = 0.0, heightP : Double = 0.0, widhtP : Double = 0.85, texto : String = ""){
        
        self.typeAlert = type
        if texto != "" {
            self.texto = texto
        }
        
        if heightC != 0.0 {
            self.height = heightC
        }
        if  widhtC != 0.0 {
            self.widht = widhtC
        }
        
        if heightP != 0.0 {
            self.height = UIScreen.main.bounds.height * heightP
        }
        if widhtP != 0.0 {
            self.widht = UIScreen.main.bounds.width * widhtP
        }
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        heightConstraint.constant = height
        widhtConstraint.constant = widht
        
        var imagen = UIImage()
        switch typeAlert {
        case .allotment:
            imagen = UIImage(named: "Alert/selectday")!
            textAlert.text = texto
        case .disconnectionAPI:
            imagen = UIImage(named: "Alert/disconnectionAPI")!
            textAlert.text = texto
        case .errorCard:
            imagen = UIImage(named: "Alert/errorCard")!
            textAlert.text = texto
        case .ferry:
            imagen = UIImage(named: "Alert/ferry")!
            textAlert.text = texto
        default :
            imagen = UIImage(named: "Alert/help")!
            textAlert.text = texto
        }
        
        self.img.image = imagen
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
