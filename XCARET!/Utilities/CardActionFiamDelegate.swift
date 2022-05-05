//
//  CardActionFiamDelegate.swift
//  XCARET!
//
//  Created by Hate on 08/12/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import Foundation
import Firebase
import FirebaseInAppMessaging
import FirebaseAnalytics

// [START fiam_card_action_delegate]
class CardActionFiamDelegate : NSObject, InAppMessagingDisplayDelegate {
    weak var delegateGoViewInAap : GoViewInAap?

    func messageClicked(_ inAppMessage: InAppMessagingDisplayMessage) {
        print("OK...")
        let appData = inAppMessage
        print(appData.campaignInfo)
    }

    func messageDismissed(_ inAppMessage: InAppMessagingDisplayMessage,
                          dismissType: FIRInAppMessagingDismissType) {
        print("OK...")
    }

    func impressionDetected(for inAppMessage: InAppMessagingDisplayMessage) {
        print("OK...")
    }

    func displayError(for inAppMessage: InAppMessagingDisplayMessage, error: Error) {
        print("OK...")
    }
    
    func messageClicked(_ inAppMessage: InAppMessagingDisplayMessage, with action: InAppMessagingAction) {
        print (action.actionURL!)
        print (action.actionURL!)
        let url = action.actionURL
//        var urlNSURL: NSURL
        let urlString: String = url?.absoluteString ?? ""

        delegateGoViewInAap?.goViewInAap(url: urlString)
    }

}
