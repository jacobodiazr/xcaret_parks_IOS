//
//  AppDelegate.swift
//  XCARET!
//
//  Created by Angelica Can on 11/6/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseInAppMessaging
import FirebaseDynamicLinks

import GoogleSignIn
import GoogleMaps
import PMAlertController
import StoreKit
import MarketingCloudSDK

import AdSupport
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var enviromentProduction : TypeEnviroment!
    var mcConfig : MarketingCloudConfig!
    weak var delegateGoViewInAap : GoViewInAap?
    
    //Catalogos de toda la informacion
    var listAllCategories : [ItemCategory] = [ItemCategory]()
    var listAllSchedules : [ItemSchedule] = [ItemSchedule]()
    var listAllSchedulesDF : [ItemSchedule] = [ItemSchedule]()
    var listAllServices : [ItemService] = [ItemService]()
    var listAllTags : [ItemTag] = [ItemTag]()
    var listAllRoutes : [ItemRoute] = [ItemRoute]()
    var listAllRestrictions : [ItemRestiction] = [ItemRestiction]()
    var listAllRestByActivity : [ItemRestrictionsByActivity] = [ItemRestrictionsByActivity]()
    var listAllAwards: [ItemAward] = [ItemAward]()
    var listAllCateByActivity : [ItemCategoryByActivity] = [ItemCategoryByActivity]()
    var listAllSubcategories : [ItemSubcategory] = [ItemSubcategory]()
    var listAllSubCatByActivity : [ItemSubcategoryByActivity] = [ItemSubcategoryByActivity]()
    var listAllServicesLocation : [ItemServicesLocation] = [ItemServicesLocation]()
    var listAllTagsByActivity : [ItemTagByActivity] = [ItemTagByActivity]()
    var listAllParksEnabled : [ItemPark] = [ItemPark]()
    var listAllParks : [ItemPark] = [ItemPark]()
    var listAllActivities : [ItemActivity] = [ItemActivity]()
    var listAllFavorites : [ItemFavorite] = [ItemFavorite]()
    var listAllMaps : [ItemMapInfo] = [ItemMapInfo]()
    var listAllFilters : [ItemFilterMap] = [ItemFilterMap]()
    var listMenuGeneral : [ItemMenu] = [ItemMenu]()
    var listLegals : [ItemLegal] = [ItemLegal]()
    var listSeason : [ItemSeason] = [ItemSeason]()
    var itemContact : ItemContact = ItemContact()
    var listCupons : [ItemCupon] = [ItemCupon]()
    var listCalendar : [ItemSeason] = [ItemSeason]()
    var listPictures : [ItemPicture] = [ItemPicture]()
    var listGallery : [ItemGallery] = [ItemGallery]()
    var bookingConfig : ItemBookingConfig!
    var listNetworkParams : [ItemNetworkParam] = [ItemNetworkParam]()
    var listTickets : [ItemTicket] = [ItemTicket]()
    var listAdmissions : [ItemAdmission] = [ItemAdmission]()
    var listAdmissionsActivities : [ItemAdmissionActivities] = [ItemAdmissionActivities]()
    var listEvents : [ItemEvents] = [ItemEvents]()
    var listCodeAyB : [ItemProductAyB] = [ItemProductAyB]()
    var appInfo : AppInfo!
    var optionsHome = false
    var URLDynamicLink = ""
    var idAction = ""
    
    //Horarios x Admision
    var listScheduleDest: [ItemScheduleDest] = [ItemScheduleDest]()
    var listDestByAdmission : [ItemDestination] = [ItemDestination]()
    
    //Contenido del programa de mano
    var listContentPrograms : [ItemContentPrograms] = [ItemContentPrograms]()
    var contentPrograms : contentPrograms!
    
    //Labels
//    var listkeyLabels: [keyLabels] = [keyLabels]()
    var listLanguages: [language] = [language]()
    var listDataLangLabel: [langLabel] = [langLabel]()
    var listDatalangProduct: [langProduct] = [langProduct]()
    
    //promociones
    var listPrecios: [ItemPrecios] = [ItemPrecios]()
    var listlangsPromotions : [Itemslangs] = [Itemslangs]()
    var listlangCatopcprom : [ItemsCatopcprom] = [ItemsCatopcprom]()
    var listlamgBenefit : [ItemsLangBenefit] = [ItemsLangBenefit]()
    var listangBenefitDesc : [ItemsLangBenefitDesc] = [ItemsLangBenefitDesc]()
    var listCurrenct : [ItemCurrency] = [ItemCurrency]()
    var listPickup : [itemsPickup] = [itemsPickup]()
    var listGeographicPickup : [itemsGeographicPickup] = [itemsGeographicPickup]()
    
    //SALES
    var listBenefits : [ItemBenefits] = [ItemBenefits]()
    var listCategoryProduct : [ItemCategoryProduct] = [ItemCategoryProduct]()
    var listCategoryPromotion : [ItemCategoryPromotion] = [ItemCategoryPromotion]()
    var listCurrencies : [ItemCurrencies] = [ItemCurrencies]()
    var listProductPrices : [ItemProductPrices] = [ItemProductPrices]()
    var listProducts : [ItemProducts] = [ItemProducts]()
    var listProductsPromotions : [ItemProductsPromotions] = [ItemProductsPromotions]()
    var listPromotionBenefit : [ItemPromotionBenefit] = [ItemPromotionBenefit]()
    var listPromotions : [ItemPromotions] = [ItemPromotions]()
    var listPromotionTabOption : [ItemPromotionTabOption] = [ItemPromotionTabOption]()
    var listTabOption : [ItemTabOption] = [ItemTabOption]()
    var listTypeProduct : [ItemTypeProduct] = [ItemTypeProduct]()
    var listItemCarShoop : [ItemCarShoop] = [ItemCarShoop]()
    var listItemLangTitle : [ItemLangTitle] = [ItemLangTitle]()
    var listItemPhoneCode : [ItemPhoneCode] = [ItemPhoneCode]()
    var listItemLangCountry : [ItemLangCountry] = [ItemLangCountry]()
    var listItemListCarshop : [ItemListCarshop] = [ItemListCarshop]()
    var listItemListCarshopReservation: [ItemCarshopReservation] = [ItemCarshopReservation]()
    var listLangTabOption : [langTabOption] = [langTabOption]()
    
    //Filtrado de las actividades por parque
    var itemParkSelected : ItemPark = ItemPark()
    var listActivitiesByPark : [ItemActivity] = [ItemActivity]()
    var listFilterMapByPark : [ItemFilterMap] = [ItemFilterMap]()
    var listServicesLocationByPark : [ItemServicesLocation] = [ItemServicesLocation]()
    var listEventsByPark : [ItemEvents] = [ItemEvents]()
    var listXOStaticData : [ItemXOStaticData] = [ItemXOStaticData]()
    var listXNStaticdata : [ItemXNStaticData] = [ItemXNStaticData]()
    var listXIStaticdata : [ItemXNStaticData] = [ItemXNStaticData]()
    var listFavoritesByPark : [ItemFavorite] = [ItemFavorite]()
    var itemMapSelected : ItemMapInfo = ItemMapInfo()
    var itemCuponActive : ItemCupon = ItemCupon()
    var listImgRestaurantsByPark : [UIImage] = [UIImage]()
    
    
    var isHightSeason: Bool = false
    var isFunctionDouble: Bool = false
    let apiKeyDirections : String = "AIzaSyA1GcvOMgtBlEgcyaUfUVTU-BO08XyBS0Q"
    let minimumRunCount = 20
    var idSalesForce : String = "uysfx1h1i"
    var yearDate = ""
    var myFiamDelegate: CardActionFiamDelegate?
    
    let getDataXapi = true
    var goShop = false
    let bookingXwitch = true
    var channelBuy = 90//Int(appDelegate.bookingConfig.channel_id!)
    var goTicketsBuy = false
    
    let timeToLiveMinimo = 5
    let timeToLiveMaximo = 1200
    
    /*Compra*/
    var validateCarshop : ValidateCarshop = ValidateCarshop()
    var currencyShop : String = "MEX"
    
    /*PHOTOS*/
    var listAlbum : [ItemAlbum] = [ItemAlbum]()
    
    /*SalesForce*/
    static var kt: KruxTracker!
    static func getKruxTracker() -> KruxTracker {
        return kt
    }
    
    /*Marketing Cloud*/
    let withMarketingCloud = true
    
    // Define features of MobilePush your app will use.
    let inbox = false
    let location = false
    let analytics = true
    var lastHtCode: String!
    /*Marketing Cloud SDK <-- */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Config NavController //Background
        //Push notifications
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
              // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
          application.registerForRemoteNotifications()
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        
        //self.myFiamDelegate = CardActionFiamDelegate()
        //InAppMessaging.inAppMessaging().delegate = myFiamDelegate;
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        
        //Icono back
        let backImage = UIImage(named: "Icons/ico_back")?.withRenderingMode(.alwaysOriginal)
        let navigationBar = UINavigationBar.appearance()
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationBar.tintColor = UIColor.white
        
        //Enviroment
        self.enviromentProduction = TypeEnviroment.production
        
        print("Enviroment Production \(self.enviromentProduction!)")
        
//        if withMarketingCloud {
            mcConfig = MarketingCloudConfig(enviroment: self.enviromentProduction)
//        }
        
        //Config Firebase
        FirebaseApp.configure()
        //Fabric.sharedSDK().debug = true.
        //PErsistencia de Datos
        self.persistenceDataBase()
        
        //Configurando GoogleSignIn
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        GMSServices.provideAPIKey("AIzaSyC3RZBAjPKFuzHjKta_z2gmJ943DCqQwHs")
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Configurando SalesForce
        FirebaseBR.shared.getCodesalesforce {
            let datamap = self.bookingConfig.datamap_ios
            if datamap != nil && datamap != ""{
                self.idSalesForce = datamap!
            }
            AppDelegate.kt = KruxTracker.sharedEventTracker(withConfigId: self.idSalesForce, debugFlag: true, dryRunFlag: false)
        }
        
        self.myFiamDelegate = CardActionFiamDelegate()
        InAppMessaging.inAppMessaging().delegate = myFiamDelegate;
        
        if let userActivityDict = launchOptions?[.userActivityDictionary] as? [UIApplication.LaunchOptionsKey : Any],
               let userActivity = userActivityDict[.userActivityType] as? NSUserActivity {
            if let incomingURL = userActivity.webpageURL {
                print("incomingURL is \(incomingURL)")
                self.URLDynamicLink = "\(incomingURL)"
            }
        }
        
        
        /*Marketing Cloud*/
//        if withMarketingCloud {
            self.configureMarketingCloudSDK()
//        }
        /*Marketing Cloud*/
        
        return true
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink){
        guard let url = dynamicLink.url else {
            print("No url")
            return
        }
        
        print("URL: \(url.absoluteString)")
        print(URLDynamicLink)
        delegateGoViewInAap?.goViewInAap(url: URLDynamicLink)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        if var incomingURL = userActivity.webpageURL {
            print("incomingURL is \(incomingURL)")
//            let urlR = "\(incomingURL)".replacingOccurrences(of: "www.", with: "")
//            incomingURL = URL(string: urlR) ?? URL(string: "https://www.xcaretpark.app")!
            self.URLDynamicLink = "\(incomingURL)"
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL){
                (dynamicLink, error) in

                guard error == nil else{
                    print("Found an error! \(error?.localizedDescription ?? "")")
                    return
                }

                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            if linkHandled{
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        print("Ok.....")
        return false
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
            let dict = userInfo["aps"] as! NSDictionary
            self.showNotificationAlert(notification: dict)
            //self.showAlertAppDelegate(title: "FTVyM 2018",message:d,buttonTitle:"OK",window:self.window!)
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
            let dict = userInfo["aps"] as! NSDictionary
            self.showNotificationAlert(notification: dict)
        }
        
//        if withMarketingCloud{
            MarketingCloudSDK.sharedInstance().sfmc_setNotificationUserInfo(userInfo)
//        }
        
        completionHandler(.newData)
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
//        if withMarketingCloud{
            Messaging.messaging().apnsToken = deviceToken
            MarketingCloudSDK.sharedInstance().sfmc_setDeviceToken(deviceToken)
//        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId : String = Settings.appID! //SDKSettings.appId
        if GIDSignIn.sharedInstance().handle(url as URL?){
            return true
        }else if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
//        if GIDSignIn.sharedInstance().handle(url as URL?,
//                                             sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                                             annotation: options[UIApplication.OpenURLOptionsKey.annotation]){
//            return true
//        }else if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
//            return ApplicationDelegate.shared.application(app, open: url, options: options)
//        }
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MobilePush SDK: OPTIONAL IMPLEMENTATION (if using Data Protection)
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
//        if withMarketingCloud {
            if(MarketingCloudSDK.sharedInstance().sfmc_isReady() == false)
            {
                self.configureMarketingCloudSDK()
            }
//        }
    }
    
    func ask4NotificationPermission(application: UIApplication){
        Messaging.messaging().shouldEstablishDirectChannel = true
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    func persistenceDataBase(){
        let typeEnviroment : TypeEnviroment = self.enviromentProduction
        Database.database(url: "https://xcaretftvym2017security.firebaseio.com/").isPersistenceEnabled = true
        //Database.database(url: "https://xcaretftvym2017photos.firebaseio.com/").isPersistenceEnabled = true
        switch typeEnviroment {
        case .preproduction:
            Database.database(url: "https://xcaretftvym2017preprod.firebaseio.com/").isPersistenceEnabled = true
            Database.database(url: "https://xcaretftvym2017ticketsprod.firebaseio.com/").isPersistenceEnabled = true
            Database.database(url: "https://xcaretftvym2017photos.firebaseio.com/").isPersistenceEnabled = true
        case .production:
            Database.database(url: "https://xcaretftvym2017.firebaseio.com/").isPersistenceEnabled = true
            Database.database(url: "https://xcaretftvym2017ticketsprod.firebaseio.com/").isPersistenceEnabled = true
            Database.database(url: "https://xcaretftvym2017photos.firebaseio.com/").isPersistenceEnabled = true
        default:
            Database.database(url: "https://parquesxcaret-dev.firebaseio.com/").isPersistenceEnabled = true
            Database.database(url: "https://xcaretftvym2017tickets.firebaseio.com/").isPersistenceEnabled = true
            Database.database(url: "https://xcaretftvym2017photosdev.firebaseio.com/").isPersistenceEnabled = true
        }
    }
    
        // MobilePush SDK: REQUIRED IMPLEMENTATION
        @discardableResult
        func configureMarketingCloudSDK() -> Bool {
            
            let builder = MarketingCloudSDKConfigBuilder()
                .sfmc_setApplicationId(mcConfig.appID)
                .sfmc_setAccessToken(mcConfig.accessToken)
                .sfmc_setMarketingCloudServerUrl(mcConfig.appEndpoint)
                .sfmc_setMid(mcConfig.mid)
                .sfmc_setInboxEnabled(inbox as NSNumber)
                .sfmc_setLocationEnabled(location as NSNumber)
                .sfmc_setAnalyticsEnabled(analytics as NSNumber)
                .sfmc_setDelayRegistration(untilContactKeyIsSet: true)//true
                .sfmc_build()!
            
            var success = false
            
            //         Once you've created the builder, pass it to the sfmc_configure method.
            do {
                try MarketingCloudSDK.sharedInstance().sfmc_configure(with:builder)
                success = true
            } catch let error as NSError {
                //             Errors returned from configuration will be in the NSError parameter and can be used to determine
                //             if you've implemented the SDK correctly.
                
                let configErrorString = String(format: "MarketingCloudSDK sfmc_configure failed with error = %@", error)
                print(configErrorString)
            }
            
            if success == true {
                //             The SDK has been fully configured and is ready for use!
                //
                //             Enable logging for debugging. Not recommended for production apps, as significant data
                //             about MobilePush will be logged to the console.
                //
                //             Make sure to dispatch this to the main thread, as UNUserNotificationCenter will present UI.
                DispatchQueue.main.async {
                    if #available(iOS 10.0, *) {
                        //                     Set the UNUserNotificationCenterDelegate to a class adhering to thie protocol.
                        //                     In this exmple, the AppDelegate class adheres to the protocol (see below)
                        //                     and handles Notification Center delegate methods from iOS.
                        UNUserNotificationCenter.current().delegate = self
                        
                        //                     Request authorization from the user for push notification alerts.
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(_ granted: Bool, _ error: Error?) -> Void in
                            if error == nil {
                                if granted == true {
                                    //                                 Your application may want to do something specific if the user has granted authorization
                                    //                                 for the notification types specified; it would be done here.
                                    print(MarketingCloudSDK.sharedInstance().sfmc_deviceToken() ?? "error: no token - was UIApplication.shared.registerForRemoteNotifications() called?")
                                }
                            }
                        })
                    }
                    
                    //                 In any case, your application should register for remote notifications *each time* your application
                    //                 launches to ensure that the push token used by MobilePush (for silent push) is updated if necessary.
                    //
                    //                 Registering in this manner does *not* mean that a user will see a notification - it only means
                    //                 that the application will receive a unique push token from iOS.
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            
            return success
        }
    /*Marketing Cloud*/
}


extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
            let dict = userInfo["aps"] as! NSDictionary
             self.showNotificationAlert(notification: dict)
        }
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
//        if withMarketingCloud {
            MarketingCloudSDK.sharedInstance().sfmc_setNotificationRequest(response.notification.request)
//        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
    func showNotificationAlert(notification : NSDictionary){
        
        let d : [String : Any] = notification["alert"] as! [String : Any]
        let body : String = d["body"] as! String
        let title : String = d["title"] as! String
        
        let alertVC = PMAlertController(title: title , description: body , image: nil , style: PMAlertControllerStyle.alert)
        alertVC.addAction(PMAlertAction(title: "Ok", style: .cancel))
        window?.rootViewController?.present(alertVC, animated: true, completion: nil)

    }
    
    func requestReview(){
        let numberRuns = AppUserDefaults.value(forKey: .NumberRuns, fallBackValue: 0)
        if numberRuns > 0 {
            if numberRuns.intValue%minimumRunCount == 0 {
                print("SI \(numberRuns) multiplo de \(minimumRunCount)")
                if #available( iOS 10.3,*){
                    SKStoreReviewController.requestReview()
                }
            }else{
                print("NO \(numberRuns) multiplo de \(minimumRunCount)")
            }
            
        }
        AppUserDefaults.save(value: numberRuns.intValue + 1, forKey: .NumberRuns)
    }
}
