//
//  Extensions.swift
//  XCARET!
//
//  Created by Angelica Can on 11/7/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import UIKit
import Firebase
//import FirebaseAuth

extension UIButton {
    
    func alignTextBelow(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font!])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [kCTFontAttributeName as NSAttributedString.Key: font])
        self.imageView?.contentMode = .scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
    
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

extension UIImage {
    
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    class func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    class func scale(image: UIImage, by scale: CGFloat) -> UIImage? {
        let size = image.size
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return UIImage.resize(image: image, targetSize: scaledSize)
    }
}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor : newValue ?? UIColor.darkGray])
        }
    }
    
    func setBottonLineDefault(){
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let borderLine = UIView()
        let height = 1.0
        let lineColorDefault = Constants.COLORS.GENERAL.colorLine
        
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        borderLine.backgroundColor = lineColorDefault
        
        self.addSubview(borderLine)
    }
    
    func isValidEmailAddress() -> Bool{
        guard let emailAddressString: String = self.text else {
            return true
        }
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}

extension Float {
    func redondear(numeroDeDecimales: Int) -> String {
        let formateador = NumberFormatter()
        formateador.maximumFractionDigits = numeroDeDecimales
        formateador.roundingMode = .down
        return formateador.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Double {
    func redondear(numeroDeDecimales: Int) -> String {
        let formateador = NumberFormatter()
        formateador.maximumFractionDigits = numeroDeDecimales
        formateador.roundingMode = .down
        return formateador.string(from: NSNumber(value: self)) ?? ""
    }
    
    func currencyFormat() -> String {
        
        let dataCurrency = appDelegate.listCurrencies.filter({ $0.currency == Constants.CURR.current }).first
        let myDoublePrice = Double(self)
        let priceNS = myDoublePrice as NSNumber
        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = dataCurrency?.miles
        formatter.groupingSize = 3
        formatter.decimalSeparator = dataCurrency?.decimal
        formatter.currencySymbol = ""//dataCurrency?.symbol ?? ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if let formattedTipAmount = formatter.string(from: priceNS) {
            return "\(dataCurrency?.symbol ?? "")\(formattedTipAmount) \(dataCurrency?.currency ?? "")"
        }else{
            return "0.00"
        }
        
    }
    
    func currencyFormatWithoutLetters() -> String {
        
        let dataCurrency = appDelegate.listCurrencies.filter({ $0.currency == Constants.CURR.current }).first
        let priceNS = self as NSNumber
        
        let formatter = NumberFormatter()
        formatter.groupingSeparator = dataCurrency?.miles
        formatter.decimalSeparator = dataCurrency?.decimal
        formatter.currencySymbol = ""//dataCurrency?.symbol ?? ""
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if let formattedTipAmount = formatter.string(from: priceNS) {
            return "\(dataCurrency?.symbol ?? "")\(formattedTipAmount)"
        }else{
            return "0.00"
        }
        
    }
    
}

extension UIViewController {
    
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        
        if #available(iOS 13, *){
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.tintColor = style == .lightContent ? UIColor.black  : .white
            self.view.addSubview(statusBar)
//            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }else{
            if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
            }
        }
    }
    
    func setBckStatusBarStryle(type: String){
        
        if #available(iOS 13, *){
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            var colorSelected = UIColor.clear
            if type != "clear" {
                colorSelected = UIColor.darkGray.withAlphaComponent(0.5)
            }
            UIView.animate(withDuration: 0.5) {
                statusBar.backgroundColor = colorSelected
            }
        }else{
            
            if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                var colorSelected = UIColor.clear
                if type != "clear" {
                    colorSelected = UIColor.darkGray.withAlphaComponent(0.5)
                }
                UIView.animate(withDuration: 0.5) {
                    statusBar.backgroundColor = colorSelected
                }
            }
            
        }
    }
    
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {//17020
            print(errorCode.errorMessage)
            UpAlertView(type: .error, message: errorCode.errorMessage).show {
                print("Error FireBase : \(errorCode.errorMessage)")
            }
        }
    }
    
    
    
    func extensionGestureHideKeyboard() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
    }
    
    @objc func hideKeyboard() {
        for sub in self.view.subviews where sub is UITextField {
            if sub.isFirstResponder {
                UIView.animate(withDuration: 0.3, animations: {
                    DispatchQueue.main.async {
                        sub.resignFirstResponder()
                    }
                })
            }
        }
    }
    
    
    func showViewControllerWith(newViewController : UIViewController, usingAnimation animationType:AnimationType){
        let currentViewController = UIApplication.shared.delegate?.window??.rootViewController
        let width = currentViewController?.view.frame.size.width;
        let height = currentViewController?.view.frame.size.height;
        
        var previousFrame:CGRect?
        var nextFrame:CGRect?
        
        switch animationType {
        case .ANIMATE_LEFT:
            previousFrame = CGRect(x: width!-1, y: 0.0, width: width!, height: height!)
            nextFrame = CGRect(x: -width!, y: 0.0, width: width!, height: height!);
        case .ANIMATE_RIGHT:
            previousFrame = CGRect(x: -width!+1, y: 0.0, width: width!, height: height!);
            nextFrame = CGRect(x: width!, y:0.0, width:width!, height:height!);
        case .ANIMATE_UP:
            previousFrame = CGRect(x:0.0, y:height!-1, width:width!, height:height!);
            nextFrame = CGRect(x:0.0, y:-height!+1, width:width!, height:height!);
        case .ANIMATE_DOWN:
            previousFrame = CGRect(x:0.0, y:-height!+1, width:width!, height:height!);
            nextFrame = CGRect(x:0.0, y:height!-1, width:width!, height:height!);
        }
        
        newViewController.view.frame = previousFrame!
        UIApplication.shared.delegate?.window??.addSubview(newViewController.view)
        UIView.animate(withDuration: 0.33, animations: { () -> Void in
            newViewController.view.frame = (currentViewController?.view.frame)!
            currentViewController?.view.frame = nextFrame!
        }){
            (finish:Bool) -> Void in
            UIApplication.shared.delegate?.window??.rootViewController = newViewController
        }
    }
    
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "lblErrAccountExist".localized()
        case .userNotFound:
            return "lbl_err_account_not_exist".getNameLabel()//"lblErrAccountNotExist".localized()
        case .userDisabled:
            return "lbl_err_account_forgot".getNameLabel()//"lblErrAccountForgot".localized()
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "lbl_err_invalid_email".getNameLabel()//"lblErrInvalidEmail".localized()
        case .networkError:
            return "lbl_err_not_network".getNameLabel()//"lblErrNotNetwork".localized()
        case .weakPassword:
            return "lbl_err_pass_weak".getNameLabel()//lblErrPassWeak".localized()
        case .wrongPassword:
            return "lbl_err_pass_incorrect".getNameLabel()//lblErrPassIncorrect".localized()
        case .credentialAlreadyInUse:
            return "Credencial en uso"
        case .accountExistsWithDifferentCredential:
            return "Tu cuenta existe con diferente credencial"
        default:
            return "lbl_error_unknow".getNameLabel()//"lblErrorUnknow".localized()
        }
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        //formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        //return (min(date1, date2) ... max(date1, date2)).contains(self)
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
}


extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true, corner: CGFloat, backgroundColor: UIColor) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.cornerRadius = corner
        layer.backgroundColor = backgroundColor.cgColor
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadowView(color: UIColor, opacity: Float = 0.5, offSet: CGSize) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
       
    }
    
    func setOvalShadow(color: UIColor = UIColor.white){
        //Removemos si exiten sublayers
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let roundPath = UIBezierPath(ovalIn: self.bounds)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = roundPath.cgPath
        maskLayer.fillColor = color.cgColor//UIColor.red.cgColor
        self.layer.addSublayer(maskLayer)
    }
    
    
    func setTrapecioShadow(){
         //var maskLayer: CAShapeLayer!
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.fillColor = UIColor.white.cgColor
        //self.layer.mask = maskLayer
        
        let headerRect = self.bounds
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y:  headerRect.height))
        path.addLine(to: CGPoint(x: headerRect.width, y:  headerRect.height))
        path.addLine(to: CGPoint(x: headerRect.width, y: (headerRect.height / 2)))

        maskLayer.path = path.cgPath
        self.layer.addSublayer(maskLayer)
    }
    
    func createShadowLayer(width: CGFloat, height: CGFloat) -> CALayer {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: width, height: height)
        shadowLayer.shadowRadius = 10
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        return shadowLayer
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func applyGradient(colours: [UIColor], direction: GradientColorDirection = .vertical) -> Void {
        self.applyGradient(colours: colours, locations: nil, cornerRadius: nil, direction : direction)
    }
    
    func applyGradient(colours: [UIColor], cornerRadius: CGFloat, direction: GradientColorDirection = .vertical)  -> Void{
        self.applyGradient(colours: colours, locations: nil, cornerRadius: cornerRadius, direction: direction)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, cornerRadius: CGFloat?, direction: GradientColorDirection = .vertical) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = cornerRadius ?? 0
        if direction == .horizontal{
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    static func nibForClass() -> Self {
        return loadNib(self)
    }
    
    static func loadNib<A>(_ owner: AnyObject, bundle: Bundle = Bundle.main) -> A {
        let nibName = NSStringFromClass(classForCoder()).components(separatedBy: ".").last!
        let nib = bundle.loadNibNamed(nibName, owner: owner, options: nil)!
        for item in nib {
            if let item = item as? A {
                return item
            }
        }
        
        return nib.last as! A
        
    }
    func addTransitionFade(_ duration: TimeInterval = 0.5) {
        let animation = CATransition()
        
        animation.type = CATransitionType.fade
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.duration = duration
        
        layer.add(animation, forKey: "kCATransitionFade")
        
    }
    
    
}

extension Bundle {
    private static var bundle: Bundle!
    
    public static func localizedBundle() -> Bundle! {
        if bundle == nil {
            
            let appLang = UserDefaults.standard.string(forKey: "app_lang") ?? Constants.LANG.current
            let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
            bundle = Bundle(path: path!)
        }
        
        return bundle;
    }
    
    public static func setLanguage(lang: String) {
        UserDefaults.standard.set(lang, forKey: "app_lang")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        bundle = Bundle(path: path!)
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
       let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        
       return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
       }.joined().dropFirst())
    }
    
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func dateFormat(format: String) -> String {
        let dateCurrentFormatter = DateFormatter()
        dateCurrentFormatter.dateFormat = format
        
        let dateNewFormatter = DateFormatter()
        dateNewFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateNewFormatter.dateFormat = Constants.LANG.current == "es" ? "dd/MM/yyyy" : "MM/dd/yyyy"
        dateNewFormatter.locale = Locale.current
        
        let date = dateCurrentFormatter.date(from: self)
        let stringDate = dateNewFormatter.string(from: date ?? Date())
        
        return stringDate
    }
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle(), value: "", comment: "")
    }
    
    func localizeWithFormat(arguments: CVarArg...) -> String{
        return String(format: self.localized(), arguments: arguments)
    }
    
    func string2Double() -> Double{
        var dataTo: Double? = 0.0
        if let dataDouble = Double(self){
            dataTo = dataDouble
        }
        return dataTo!
    }
    
    func getNameLabel() -> String {
        
        let lang: [langLabel]? = appDelegate.listDataLangLabel.filter({$0.uid == Constants.LANG.current})
        
        let lagnName = lang!.filter({$0.lbl_key == self}).first
        let aux = lang?.first
        if lang != nil && lagnName != nil{
            return lagnName!.name
        }else{
            return "Loading..."
        }
        
    }
    
    func isValidEmail() -> Bool {
        let inputRegEx = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9._%+-]+\\.[A-Za-z]{2,64}"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    
    func isValidFolioTicket() -> Bool {
        let inputRegEx = "((AM)|(CC)|(PW))[0-9]{2,64}"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
}


extension UINavigationBar {
    func setGradientBackground(colors: [Any]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.locations = [0.0 , 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        var updatedFrame = self.bounds
        updatedFrame.size.height += self.frame.origin.y
        gradient.frame = updatedFrame
        gradient.colors = colors;
        self.setBackgroundImage(self.image(fromLayer: gradient), for: .default)
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
}

extension SearchViewController: UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .black
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        //Filter function
        self.filterActivities(searchText: searchText, isCancel: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        guard let term = searchBar.text, term.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty == false else {
            return
        }
        
        //Filter function
        self.filterActivities(searchText: term, isCancel: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
        
        
        //Filter function
        self.filterActivities(searchText: searchBar.text!, isCancel: true)
    }
}

extension UIColor {
    func parseSplitedStringToColor(separatedBy: String, colorText: String)-> UIColor{
        let separedColor = colorText.components(separatedBy: separatedBy)
        
        guard separedColor.count >= 3 else {
            return .white
        }

        if let red = Double(separedColor[0]), let green = Double(separedColor[1]), let blue = Double(separedColor[2]) {
            return UIColor.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
        }else{
            return .white
        }
    }
}
