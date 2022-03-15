//
//  ViewController.swift
//  MYNA
//
//  Created by mac on 04/03/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    private let arrFiveHourIntervel = [9,13,17,21]
    private let arrFourHourIntervel = [9,12,15,18,21]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestAuthorization()
    }
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
               self.checkTimeSlotsforFourHours()
               self.checkTimeSlotsforFiveHours()
            } else {
            }
        }
    }
}

// MARK: Add and Remove Notification
extension ViewController {
    private func checkTimeSlotsforFourHours() {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 9...21:
            let filteredLangNames = self.arrFourHourIntervel.filter { (remainingInterval) -> Bool in
                return remainingInterval > hour
            }
            self.triggerNotification(filteredLangNames, "Attention")
        case 0...8:
            self.triggerNotification(self.arrFourHourIntervel, "Attention")
        case 22...24:
            debugPrint("hour is greater then 21")
        default:
            debugPrint("hour is greater then 24")
        }
    }
    
    private func checkTimeSlotsforFiveHours() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 9...21:
            let filteredLangNames = self.arrFiveHourIntervel.filter { (remainingInterval) -> Bool in
                return remainingInterval > hour
            }
            self.triggerNotification(filteredLangNames, "Here and now, boys")
        case 0...8:
            self.triggerNotification(self.arrFiveHourIntervel, "Here and now, boys")
        case 22...24:
            debugPrint("hour is greater then 21")
        default:
            debugPrint("hour is greater then 24")
        }
    }
    
    private func triggerNotification(_ arrTimeIntervels: [Int], _ body: String) {
        for time in arrTimeIntervels {
            // Create the content of the notification
            let content = UNMutableNotificationContent()
                content.title = "Alert"
                content.body = body
            
            // Create the request
            let request = UNNotificationRequest(identifier: "\(body) \(String(time))",content: content, trigger:  UNCalendarNotificationTrigger(dateMatching: DateComponents.triggerFor(time: time), repeats: true))
            
            // Schedule the request with the system.
             UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}

extension DateComponents {
    static func triggerFor(time: Int) -> DateComponents {
        var component = DateComponents()
        component.calendar = Calendar.current
        component.timeZone = NSTimeZone.system
        component.hour = time
        component.minute = 0
        component.second = 0
        return component
    }
}
