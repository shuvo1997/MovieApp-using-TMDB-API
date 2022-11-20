//
//  NotificationManager.swift
//  MovieApp
//
//  Created by BS1010 on 16/11/22.
//

import Foundation
import SwiftUI

class MyNotificationManager {
    
    static let showAlertMsg = Notification.Name("Alert_MSG")
    
    static let alertNotificationPublisher = NotificationCenter.default.publisher(for: MyNotificationManager.showAlertMsg, object: nil)
    
    static func postNotification() {
        print("Notification posted")
        NotificationCenter.default.post(name: showAlertMsg, object: nil)
    }
    
}
