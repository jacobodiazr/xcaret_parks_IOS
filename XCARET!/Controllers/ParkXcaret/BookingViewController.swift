//
//  BookingViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 7/8/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import WebKit

class BookingViewController: UIViewController, WKNavigationDelegate, ManageBuyPromDelegate {
    
    weak var delegateGoMenuTickets : GoMenuTickets?
    var webView : WKWebView!
    var itemBooking : ItemBookingConfig!
    var itemParams : ItemNetworkParam!
    var itemBuyProm : [ItemProdProm] = [ItemProdProm]()
    var titleWebView : String! = ""
    var callingCode : String! = "Buy" //"Ticket"
    var typeLoad : String = "IN" // "IN" Index, "BCK" Back
    var currentUrl : String = ""
    var typeItemBuyXV : String = ""
    //Valores para pasar por analytics
    var analytics_price : String = ""
    var analytics_pax : String = ""
    var analytics_currency : String = ""
    var analytics_name : String = ""
    //HOME
    @IBOutlet weak var viewBarHome: UIView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var viewClose: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        print(self.titleWebView.uppercased())
        self.title = self.titleWebView.uppercased()
        self.analytics_name = self.titleWebView.uppercased()
        
        itemBooking = appDelegate.bookingConfig
        clearCache()
        makeUrlPage()
        print("callingCode : \(callingCode!)")
        
        //Creamos el boton para el call center
        let rightButton = UIBarButtonItem(image: UIImage(named: "Icons/ic_telefono"), style: .plain, target: self, action: #selector(goCallCenter))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        print(analytics_price)
        AnalyticsBR.shared.contenView(name: self.analytics_name, category: TagsCategoryCart.Parks.rawValue, price: self.analytics_price, currency: Constants.CURR.current.uppercased())
        
        if #available(iOS 13.0, *) {}else{
            configButtonClose()
        }
        
        
        
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func clearCache(){
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[WebCacheCleaner] All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
    }
    
    @objc private func goCallCenter(){
        let mainNC = AppStoryboard.Hotel.viewController(viewControllerClass: CallCenterHotelViewController.self)
        mainNC.type = "Booking"
        self.present(mainNC, animated: true)
    }
    
    func makeUrlPage(){
        if itemBooking != nil {
            let aux2 = itemBooking
            var urlPage = ""
            var dynamics = ""
            let aux = appDelegate.itemParkSelected
            var product = "?product=\(appDelegate.itemParkSelected.product_name!)"
            var T = 0
            var C = 0
            var P = 0
            var D = 0
            var couponCode = ""
            if itemBuyProm.count > 0{
                let aux2 = itemBuyProm
                product = "?product=\(itemBuyProm.first!.code_landing ?? "")"
                T = itemBuyProm.first!.transportation
                C = itemBuyProm.first!.food
                P = itemBuyProm.first!.photopass
                D = itemBuyProm.first!.extra_day
                couponCode = itemBuyProm.first!.cupon_promotion
            }
            if appDelegate.itemParkSelected.code == "XV" {
                if self.typeItemBuyXV != "" {
                    product = "?product=\(self.typeItemBuyXV)"
                }else{
                    product = "?product=\(appDelegate.itemParkSelected.product_name ?? "")"
                }
                self.typeItemBuyXV = ""
                if callingCode == "Ticket" {
                    product = "?product=\(appDelegate.listAdmissions.first?.ad_code! ?? "")"
                }
            }
            //Añadimos parametros
            dynamics += "&lang=\(Constants.LANG.current.lowercased())"
            dynamics += "&curr=\(Constants.CURR.current.uppercased())"
            
            if itemBuyProm.count > 0 {
                dynamics += "&T=\(T)"
                dynamics += "&C=\(C)"
                dynamics += "&P=\(P)"
                dynamics += "&D=\(D)"
                dynamics += "&couponCode=\(couponCode)"
                urlPage = itemBooking!.url + product + dynamics
            }else{
                urlPage = itemBooking!.url + product + dynamics + appDelegate.itemParkSelected.bookingParams
            }

            print("url: \(urlPage)")
            let url = URL(string: urlPage)!
            let urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
            webView.load(urlRequest)
            print("Price...")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setStatusBarStyle(.default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = Constants.COLORS.GENERAL.navBooking
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icons/ic_cerrarweb")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(goBackUrl))
        
//        if appDelegate.optionsHome{
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
//            self.viewClose.addGestureRecognizer(tapRecognizer)
//        }else{
//            viewBarHome.isHidden = true
//        }
        
    }
    
    
    
    
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func sendBuyProm(itemProm: [ItemProdProm]) {}
    
    func sendPreBuyProm(itemProm: [ItemProdProm]) {}
    func sendPreBuyPromBook(){}
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goPopUpPreBuy"{
            if let popupPreBuy = segue.destination as? popUpPreBuyViewController {
                popupPreBuy.delegatePreBuyProm = self
            }
        }
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if let currentURL = webView.url?.absoluteString{
                print("Page : \(currentURL)")
                self.currentUrl = currentURL
                self.setTypeLoad()
                //BORRAR
//                self.configButton()
                if currentURL.contains(self.itemBooking.step_one){
                    
                    let js = self.getJSPrice()
                    self.webView.evaluateJavaScript(js) { (result, error) in
                        if let result = result {
                            let dataReserve = "\(result)".split(separator: "$")
                            var count = 1
                            for itemInfo in dataReserve {
                                if count == 1 {
                                    self.analytics_price = String(itemInfo)
                                }
                                if count == 2{
                                    self.analytics_pax = String(itemInfo)
                                }
                                if count == 3{
                                    self.analytics_currency = String(itemInfo)
                                }
                                count += 1
                            }
                    AnalyticsBR.shared.addToCart(name: self.analytics_name, category: TagsCategoryCart.Parks.rawValue, price: self.analytics_price, currency: self.analytics_currency, quantity: self.analytics_pax)
//                            AnalyticsBR.shared.purchase(name: self.analytics_name, category: TagsCategoryCart.Parks.rawValue, price: self.analytics_price, currency: self.analytics_currency, quantity: self.analytics_pax)
                            
                            
                        }
                    }
                }
                
                if currentURL.contains(self.itemBooking.step_two){
                    AnalyticsBR.shared.beginCheckout(name: self.analytics_name, category: TagsCategoryCart.Parks.rawValue, price: self.analytics_price, currency: self.analytics_currency, quantity: self.analytics_pax)
                    
//                    self.performSegue(withIdentifier: "goPopUpPreBuy", sender: nil)
                    
                }
                
                //Cuando llegó al final de la compra y retorna el folio de la admision.
                if currentURL.contains(self.itemBooking.final_url){
                    //Ocultamos el back Button
                    self.navigationItem.leftBarButtonItem = nil
                    let js = self.getJSResponse()
                    self.webView.evaluateJavaScript(js) { (result, error) in
                        if let result = result {
                            print(result)
                            //let getCupon = result as? String ?? ""
                            //if !getCupon.isEmpty {
                            self.saveTicket(cupon: "\(result)")
                                
                                //Guardar en firebase
                            //}
                        }
                    }
                }
            }
        })
    }
    
    func configButton(){
        let button = UIButton(frame: CGRect(x: 0, y: self.webView.bounds.height - UIDevice().getHeightViewCode(), width: self.webView.bounds.width, height: UIDevice().getHeightViewCode()))
        button.backgroundColor = Constants.COLORS.TICKETS.colorBuy
        button.setTitle("lbl_btn_go_tickets".getNameLabel()/*"lblBtnGoTickets".localized()*/, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentVerticalAlignment = .top
        button.contentEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 10, right: 10)
        button.setImage(UIImage(named: "Tickets/btnTicket"), for: .normal)
        button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
        
        
        
//        let viewTest = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
//        viewTest.backgroundColor = .red
//            
//        
//        self.webView.addSubview(viewTest)
        self.webView.addSubview(button)
    }
    
    func configButtonClose(){
        let button = UIButton(frame: CGRect(x: 10, y: UIDevice().setTopButtonCloseBuy(), width: 35, height: 35))
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentVerticalAlignment = .top
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setImage(UIImage(named: "Icons/ic_cerrarweb"), for: .normal)
        button.addTarget(self, action: #selector(closeViewBuy), for: .touchUpInside)
        self.webView.addSubview(button)
    }
    
    @objc func closeViewBuy(){
        self.dismiss(animated: true)
    }
    
    func addCar(itemProm: [ItemProdProm]) {
    }
    
    
    @objc func ratingButtonTapped(){
        print("Button pressed")
        
        if self.callingCode == "Buy"{
            // store tabBarController for later use
            let tabBarController = self.tabBarController
            // pop to root vc (green one)
            _ = self.navigationController?.popToRootViewController(animated: false)
            // switch to 2nd tab (red vc)
            
            print("count items tabbar \(tabBarController?.viewControllers?.count ?? 0)")
            //tabBarController?.selectedIndex = appDelegate.itemParkSelected.code == "XV" ? 2 : 3
            tabBarController?.selectedIndex = (tabBarController?.viewControllers?.count ?? 1) - 1
        }else if self.callingCode == "Promo"{
            self.dismiss(animated: true) {
                
                self.delegateGoMenuTickets?.goMenuTickets()
                //Enviar a tab controller correspondiente
                //self.tabBarController?.selectedIndex = (self.tabBarController?.viewControllers?.count ?? 1) - 1
            }
        }else{
            _ = self.navigationController?.popViewController(animated: true)
            //self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func saveTicket(cupon: String){
        if !cupon.isEmpty{
            LoadingView.shared.showActivityIndicator(uiView: self.view, type: .loadTicket)
            FirebaseDB.shared.saveTicket(cupon: cupon) { (success) in
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                if success {
                    print("Se guardó cupon \(cupon)")
                    self.configButton()
                    AnalyticsBR.shared.purchase(name: self.analytics_name, category: TagsCategoryCart.Parks.rawValue, price: self.analytics_price, currency: self.analytics_currency, quantity: self.analytics_pax)
                }
            }
        }
    }
    
    func setTypeLoad(){
        if self.currentUrl.contains(itemBooking!.url){
            //Index
            self.typeLoad = "IN"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icons/ic_cerrarweb")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(goBackUrl))
        }else{
            self.typeLoad = "BCK"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icons/ico_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(goBackUrl))
        }
    }
    
    func getJSPrice() -> String{
        return "(function() { \n" +
            " var result = \"\"; \n" +
            " var total = \"\"; \n" +
            " var currency = \"\"; \n" +
            " var quantity = 0; \n" +
         "if(document.getElementById('content_total')!= null){ \n" +
         " var price = (document.getElementById('content_total').innerHTML); \n" +
         " var arrayprice = price.split(\"<sup>\"); \n" +
         " if(arrayprice.length >=2){ \n" +
           " var firstPos = arrayprice[0]; \n" +
           " var secondPos = arrayprice[1]; \n" +
           " var totalArray = firstPos.split(\"$\"); \n" +
           "  if(totalArray.length >= 2){ \n" +
           "   total = totalArray[1].trim(); \n" +
           " } \n" +
           " var currencyArray = secondPos.split(\"</sup>\"); \n" +
           " if(currencyArray.length >= 2){ \n" +
           "   total += currencyArray[0].trim(); \n" +
           "   currency = currencyArray[1].trim(); \n" +
           " } \n" +
         " } \n" +
         " var adults = document.getElementsByClassName(\"input-sm adult\")[0]; \n" +
         " var childs = document.getElementsByClassName(\"input-sm child\")[0]; \n" +
         " var infants = document.getElementsByClassName(\"input-sm infant\")[0]; \n" +
         " if(adults != null){ \n" +
           " quantity += parseInt(adults.options[adults.selectedIndex].text,10); \n" +
         " } \n" +
         " if(childs != null){ \n" +
           " quantity += parseInt(childs.options[childs.selectedIndex].text,10); \n" +
         "} \n" +
         " if(infants != null){ \n" +
           " quantity += parseInt(infants.options[infants.selectedIndex].text,10); \n" +
         "} \n" +
           " result = total+\"$\"+quantity.toString()+\"$\"+ currency; \n" +
         "} \n" +
         " return result; \n" +
         " })(); \n"
    }

    func getJSResponse() -> String{
        return "(function() { \n" +
            " var result = \"\";\n" +
            " if(document.getElementById('content_paymentOrder')!= null){\n" +
            "  var cupon = (document.getElementById('content_paymentOrder').innerHTML); \n" +
            "  var arrayCupon = cupon.split(\"</strong>\");\n" +
            "  if(arrayCupon.length >=2)\n" +
            "     result = arrayCupon[1];\n" +
            "  }\n" +
            "\n" +
            "  return result;\n" +
        "  })();"
    }
    
    func getJSBackUrl() -> String{
        return "(function() { \n" +
            " if(document.getElementById('content_cshopping')!= null){\n" +
            "  document.getElementById('content_cshopping').click(); \n" +
            "  }\n" +
            " if(document.getElementById('content_btnBack')!= null){\n" +
            "  document.getElementById('content_btnBack').click(); \n" +
            "  }\n" +
        "  })();"
    }

    /*func removeCookies(){
        let cookie = HTTPCookie.self
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }*/

    @objc func goBackUrl(){
        if typeLoad == "IN" {
            _ = self.navigationController?.popViewController(animated: true)
        }else{
            let js = getJSBackUrl()
            self.webView.evaluateJavaScript(js) { (result, error) in
                if let result = result {
                    print(result)
                }
            }
        }
    }
}
