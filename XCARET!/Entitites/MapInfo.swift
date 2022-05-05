//
//  MapInfo.swift
//  XCARET!
//
//  Created by Angelica Can on 11/20/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation

open class MapInfoByPark {
    func getStyle(keycode: String) -> String{
        switch keycode {
        case "XC":
            return styleXcaret()
        default:
            return styleXcaret()
        }
    }
    
    func styleXcaret() -> String{
        let style = "[\n" +
            "  {\n" +
            "    \"elementType\": \"labels\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"administrative\",\n" +
            "    \"elementType\": \"geometry\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"administrative.land_parcel\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"administrative.neighborhood\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"landscape.natural\",\n" +
            "    \"elementType\": \"geometry\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"color\": \"#DEFEB0\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"poi\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"road\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"road\",\n" +
            "    \"elementType\": \"labels.icon\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"transit\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  }\n" +
        "]";
        
        return style
    }
}

open class MapInfo {
    
    var latitude : Double
    var longitude : Double
    var defaultZoom : Float
    var imgOverlay : String
    var limitA_lat : Double
    var limitA_long : Double
    var limitB_lat : Double
    var limitB_long : Double
    var maxZoom : Float
    var minZoom : Float
    var overNE_lat : Double
    var overNE_long : Double
    var overSW_lat : Double
    var overSW_long : Double
    var style : String
    
    init() {
        latitude = 20.580600
        longitude = -87.119952
        defaultZoom = 18
        imgOverlay = "mapaxc.jpg"
        limitA_lat = 20.58554
        limitA_long = -87.12534
        limitB_lat = 20.57578
        limitB_long = -87.11467
        maxZoom = 19
        minZoom = 17
        overNE_lat = 20.5866
        overNE_long = -87.11336
        overSW_lat = 20.57435
        overSW_long = -87.12662
        style = "[\n" +
            "  {\n" +
            "    \"elementType\": \"labels\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"administrative\",\n" +
            "    \"elementType\": \"geometry\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"administrative.land_parcel\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"administrative.neighborhood\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"landscape.natural\",\n" +
            "    \"elementType\": \"geometry\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"color\": \"#DEFEB0\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"poi\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"road\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"road\",\n" +
            "    \"elementType\": \"labels.icon\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  },\n" +
            "  {\n" +
            "    \"featureType\": \"transit\",\n" +
            "    \"stylers\": [\n" +
            "      {\n" +
            "        \"visibility\": \"off\"\n" +
            "      }\n" +
            "    ]\n" +
            "  }\n" +
        "]";
    }
}
