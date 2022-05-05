//
//  File.swift
//  XCARET!
//
//  Created by Angelica Can on 4/10/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation

open class PhotoBR {
    static let shared = PhotoBR()
    
    func existCodeFB(code: String, completion: @escaping (_ exist : Bool) -> ()){
        if appDelegate.listAlbum.first(where: {$0.code == code}) != nil{
            completion(true)
        }else{
            completion(false)
        }
    }
    
    func validateAlbumUnlock(code: String, parkID: Int, completion: @escaping (_ isUnlock : Bool) -> ()){
        var isValid : Bool = false
        PhotoDB.shared.getSelectedParks(code: code, completion: { (selectedList) in
            if selectedList.count > 0 {
                for item in selectedList {
                    if item == parkID{
                        isValid = true
                    }
                }
            }
            completion(isValid)
        })
    }
    
    
    func validateCode(code: String, completion: @escaping (_ isValid : Bool, _ album: ItemAlbum) -> ()){
        var isValid : Bool = false
        var album : ItemAlbum = ItemAlbum()
        //Validamos el codigo de descarga
        PhotoDB.shared.validateCode(code: code) { (isValidCode, itemAlbum)  in
            isValid = isValidCode
            album = itemAlbum
            //Si es valido, verificamos si es hotel o un solo album
            if isValid {
                //Si el album es válido, validar cuantos ya seleccionó
                if itemAlbum.isBook {
                    PhotoDB.shared.getSelectedParks(code: code, completion: { (selectedList) in
                        if selectedList.count > 0 {
                            album.totalUnlock = selectedList.count
                        }
                        PhotoDB.shared.getAlbums(code: code, isBook: itemAlbum.isBook, selectedList: selectedList, completion: { (listAlbumDetail) in
                            album.listAlbumesDet = listAlbumDetail
                            FirebaseBR.shared.validateAlbum(album: album, completion: { (suceess) in
                                print("Existe")
                            })
                            completion(isValid, album)
                        })
                    })
                }else{
                    PhotoDB.shared.getAlbums(code: code, isBook: itemAlbum.isBook, selectedList: [], completion: { (list) in
                        //Verificamos que el album traiga el totalMedia
                        if list.count > 0 {
                            let itemAlbum = list[0]
                            album.listAlbumesDet = [itemAlbum]
                            FirebaseBR.shared.validateAlbum(album: album, completion: { (suceess) in
                                print("Existe")
                            })
                            completion(isValid, album)
                            //Eliminar después de pruebas
//                            PhotoDB.shared.getTotalByAlbumPark(code: code, parkId: itemAlbum.parkId, completion: { (totalMediaAlbum) in
//                                itemAlbum.totalMedia = totalMediaAlbum
//
//                            })
                        }else{
                            completion(isValid, album)
                        }
                    })
                }
            }else{
                //Actualizar el Firebase
                //FirebaseDB.shared.updateStatusAlbum(itemAlbum: album) { (success) in
                    //print("se actualización status album \(album.isValid!)")
                //}
                completion(isValid, album)
            }
        }
    }
    
    func getPhoto(code: String, parkId: Int, completion: @escaping ([ItemPhoto]) -> ()){
        let current : Int = 1
        let group = DispatchGroup()
        var listAlbumPhotos : [ItemPhoto] = [ItemPhoto]()
        
        //print("current: \(current) pages: \(pages)")
        PhotoDB.shared.getPhotosReloaded(code: code, parkId: parkId, current: current) { (listAlbumPage, totalPages, currentPage) in
            print("Pagina \(currentPage)")
            listAlbumPhotos.append(contentsOf: listAlbumPage)
            //Validamos si tiene más de una página
            if (totalPages >= currentPage && totalPages > 1) {
                //Recorremos apartir de la segunda pagina
                DispatchQueue.global(qos: .userInitiated).async {
                    for page in currentPage+1...totalPages {
                        group.enter()
                        print("Pagina \(page)")
                        PhotoDB.shared.getPhotosReloaded(code: code, parkId: parkId, current: page) { (listAlbumComplement, totalPagesComplement, currentPageComplement ) in
                            listAlbumPhotos.append(contentsOf: listAlbumComplement)
                            group.leave()
                            if totalPages == currentPageComplement {
                                completion(listAlbumPhotos)
                            }
                        }
                        group.wait()
                    }
                }
            }else{
                completion(listAlbumPhotos)
            }
        }
    }
    
    func saveAlbumUnlock(code: String, parkId: Int, completion: @escaping (Bool)->()){
        if !code.isEmpty && parkId > 0{
            PhotoDB.shared.saveAlbumUnlock(code: code, parkId: parkId) { (successSave) in
                //Si se guardó
                if successSave{
                    FirebaseDB.shared.updateAlbumByUser(code: code, parkId: parkId, completion: { (success) in
                        completion(success)
                    })
                }else{
                    completion(false)
                }
            }
        }else{
            completion(false)
        }
    }
    
    func sendUrl(email: String, photoCode: String, completion: @escaping(Bool) -> ()){
        PhotoDB.shared.sendUrl(email: email, photoCode: photoCode, completion: completion)
    }
}
