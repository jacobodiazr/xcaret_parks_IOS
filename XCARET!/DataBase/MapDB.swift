//
//  MapDB.swift
//  XCARET!
//
//  Created by Angelica Can on 2/1/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

open class MapDB{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let shared = MapDB()
    var timerAnimation: Timer!
    
    open func getRouteMapPath(latA: String, lonA: String, latB: String, lonB: String, completion: @escaping (_ path: GMSPath) -> ()){
        var path : GMSPath!
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(latA),\(lonA)&destination=\(latB),\(lonB)&key=\(appDelegate.apiKeyDirections)&mode=walking&avoid=tolls,highways,ferries"
        print(url)
        
        WebService.shared.execute(url: url, httpMethod: .get, params: nil) { (success, json) in
            let routes = json["routes"].arrayValue
            for route in routes {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                path = GMSPath.init(fromEncodedPath: points!)
            }
            completion(path)
        }
        
    }
    
    open func getRouteMap(latA: String, lonA: String, latB: String, lonB: String, completion: @escaping (_ polyline: GMSPolyline) -> ()){
        //var path : GMSPath!
        var polyline : GMSPolyline!
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(latA),\(lonA)&destination=\(latB),\(lonB)&key=\(appDelegate.apiKeyDirections)&mode=walking&avoid=tolls,highways,ferries"
        print(url)
        
        WebService.shared.execute(url: url, httpMethod: .get, params: nil) { (success, json) in
            let routes = json["routes"].arrayValue
            for route in routes {
                let redYellow = GMSStrokeStyle.gradient(from: .red, to: .yellow)
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 7
                polyline.strokeColor = Constants.COLORS.GENERAL.linePolyline
                polyline.geodesic = true
                polyline.spans = [GMSStyleSpan(style: redYellow)]
                
                let legs = route["legs"].arrayValue
                for leg in legs {
                    let steps = leg["steps"].arrayValue
                    for step in steps {
                        print(step)
                    }
                }
            }
            completion(polyline)
        }
        
    }
}
