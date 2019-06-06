//
//  FireBaseNotificationSender.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/4.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

class FireBaseNotificationSender {
  
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to": token,
                                           "notification" : ["title": title, "body": body],
                                           "data": ["user": "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "key=AAAAt6gibDA:APA91bHolzppEfyj3snmmGzUv0aYMzaInKTXXWVc29ndxDMyDqoX76nSPe_Eh2KNtRxz94SWSAyQhalDyybHdRoDa3RvCHyrY81oO-8p4_UBiuUynFcUfjD5hhtwmzO-zvDcBw5ZsidD",
            forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
