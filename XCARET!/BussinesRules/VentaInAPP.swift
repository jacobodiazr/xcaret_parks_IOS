//
//  VentaInAPP.swift
//  XCARET!
//
//  Created by Yeik on 03/05/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import Foundation

open class VentaInAPP {
    static let shared = VentaInAPP()
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    private let ref: DatabaseReference? = Database.database().reference()
    
    
    func getDataParksPrice(completion:@escaping () -> Void){
        FirebaseDB.shared.getlistBenefits(completion:{ (listBenefits) in
            FirebaseDB.shared.getlistCategoryProduct(completion:{ (listCategoryProduct) in
                FirebaseDB.shared.getlistCategoryPromotion(completion:{ (listCategoryPromotion) in
                    FirebaseDB.shared.getlistCurrencies(completion:{ (listCurrencies) in
                        FirebaseDB.shared.getlistProductPrices(completion:{ (listProductPrices) in
                            FirebaseDB.shared.getlistProducts(completion:{ (listProducts) in
                                FirebaseDB.shared.getlistProductsPromotions(completion:{ (listProductsPromotions) in
                                    FirebaseDB.shared.getlistPromotionBenefit(completion:{ (listPromotionBenefit) in
//                                        FirebaseDB.shared.getlistPromotions(completion:{ (listPromotions) in
                                            FirebaseDB.shared.getlistPromotionTabOption(completion:{ (listPromotionTabOption) in
                                                FirebaseDB.shared.getlistTabOption(completion:{ (listTabOption) in
                                                    FirebaseDB.shared.getlistTypeProduct(completion:{ (listTypeProduct) in
                                                        FirebaseDB.shared.getLangProduct(completion:{ (listTypeProduct) in
                                                            FirebaseDB.shared.getLangProductEN(completion:{ (listTypeProduct) in
                                                                FirebaseDB.shared.getListPreciosXapi(completion:{ (ListPreciosXap) in
//                                                                    FirebaseDB.shared.getListPickup(completion : {(itemsPickup) in
                                                                        FirebaseDB.shared.getListGeographicPickup (completion : {(itemsPickup) in
                                                                            FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                                                FirebaseDB.shared.getListTituloES (completion : {(itemsListTituloES) in
                                                                                    FirebaseDB.shared.getListTituloEN(completion : {(itemsListTituloEN) in
                                                                                        FirebaseDB.shared.getListPhoneCode(completion : {(itemsListPhoneCode) in
                                                                                            FirebaseDB.shared.getListLangCountryES(completion : {(itemsListLangCountryES) in
                                                                                                FirebaseDB.shared.getListLangCountryEN(completion : {(itemsListLangCountryEN) in
                                                                                                    FirebaseDB.shared.getListLangTabOptionES(completion : {(itemsListLangTabOptionES) in
                                                                                                        FirebaseDB.shared.getListLangTabOptionEN(completion : {(itemsListListLangTabOptionEN) in
                                                                                                            FirebaseDB.shared.getListlangCatopcprom(completion : {(itemsListItemsCatopcprom) in
                                                                                                                FirebaseDB.shared.getListLangBenefit(completion : {(listLangBenefit) in
                                                                                                                    completion()
                                                                                                                })
                                                                                                            })
                                                                                                        })
                                                                                                    })
                                                                                                })
                                                                                            })
                                                                                        })
                                                                                    })
                                                                                })
                                                                            })
                                                                        })
//                                                                    })
                                                                })
                                                            })
                                                        })
                                                    })
                                                })
                                            })
//                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
    }
}
