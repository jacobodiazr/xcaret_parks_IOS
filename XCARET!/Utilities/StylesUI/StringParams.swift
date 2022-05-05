//
//  StringParams.swift
//  XCARET!
//
//  Created by Angelica Can on 5/6/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation
import UIKit

open class StringParams{
    static let shared = StringParams()
    
    func getStringFormat(code: String, params: [String]) -> NSMutableAttributedString{
        var attributeText: NSMutableAttributedString!
        switch code {
        case "lblLoadAlbumsPack":
            if Constants.LANG.current == "es"{
                let loadAlbums = NSMutableAttributedString(string: "Compraste un paquete de fotos que incluye ")
                loadAlbums.append(NSMutableAttributedString(string: "\(params[0])", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                loadAlbums.append(NSMutableAttributedString(string: " parques. Tus fotos en el hotel están incluidas.\n\n"))
                loadAlbums.append(NSMutableAttributedString(string: "Desbloqueados: "))
                loadAlbums.append(NSMutableAttributedString(string: "\(params[1])\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                loadAlbums.append(NSMutableAttributedString(string: "Pendientes: \(params[2])", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                attributeText = loadAlbums
            }else{
                let loadAlbums = NSMutableAttributedString(string: "You bought a photo package that include ")
                loadAlbums.append(NSMutableAttributedString(string: "\(params[0])", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                loadAlbums.append(NSMutableAttributedString(string: " parks and you have. The hotel photos are included.\n\n"))
                loadAlbums.append(NSMutableAttributedString(string: "Unlocked: "))
                loadAlbums.append(NSMutableAttributedString(string: "\(params[1])\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                loadAlbums.append(NSMutableAttributedString(string: "Pending: \(params[2])", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                attributeText = loadAlbums
            }
            
        case "lblUnlockAlbums":
            if Constants.LANG.current == "es"{
                let loadAlbums = NSMutableAttributedString(string: "Compraste un paquete que incluye fotos para ")
                loadAlbums.append(NSMutableAttributedString(string: "\(params[0]) parques.\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy)]))
                
                loadAlbums.append(NSMutableAttributedString(string: "Desbloqueados: "))
                loadAlbums.append(NSMutableAttributedString(string: "\(params[1])\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                loadAlbums.append(NSMutableAttributedString(string: "Pendientes: \(params[2])", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                loadAlbums.append(NSMutableAttributedString(string: "\n\n¿Estás seguro que deseas desbloquear este parque?"))
                attributeText = loadAlbums
            }else{
                //"You bought a photo package that includes %@ parks and you have %@ left unlocked to complete it.\nAre you sure you want to unlock this park?"
                let loadAlbums = NSMutableAttributedString(string: "You bought a photo package that includes ")
                loadAlbums.append(NSMutableAttributedString(string: "\(params[0]) parks.\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)]))
                
                loadAlbums.append(NSMutableAttributedString(string: "Unlocked: "))
                loadAlbums.append(NSMutableAttributedString(string: "\(params[1])\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                loadAlbums.append(NSMutableAttributedString(string: "Pending: \(params[2])", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                
                loadAlbums.append(NSMutableAttributedString(string: "\n\nAre you sure you want to unlock this park?"))
                attributeText = loadAlbums
            }
        case "lblExcedUnlock" :
            if Constants.LANG.current == "es"{
                let loadAlbums = NSMutableAttributedString(string: "Compraste un paquete de fotos que incluye ")
                loadAlbums.append(NSMutableAttributedString(string: "\(params[0])", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                loadAlbums.append(NSMutableAttributedString(string: " parques. Tus fotos en el hotel están incluidas.\n\n"))
                loadAlbums.append(NSMutableAttributedString(string: "!Felicidades, ya completaste tus álbumes!", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                attributeText = loadAlbums
            }else{
                let loadAlbums = NSMutableAttributedString(string: "You bought a photo package that include ")
                loadAlbums.append(NSMutableAttributedString(string: "\(params[0])", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                loadAlbums.append(NSMutableAttributedString(string: " parks and you have. The hotel photos are included.\n\n"))
                loadAlbums.append(NSMutableAttributedString(string: "Congratulations, you have completed your albums!", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .heavy) ]))
                attributeText = loadAlbums
            }
        default:
            print("x")
        }
        
        return attributeText
    }
}
