//
//  MessagingManager.swift
//  RXBTLEMessaging
//
//  Created by Nico Ameghino on 8/27/17.
//  Copyright © 2017 Nico Ameghino. All rights reserved.
//

import Foundation
import CoreBluetooth
import CocoaLumberjack

extension CBUUID {
    public static let messagingServiceUUID = CBUUID(string: "C016F021-D456-45AF-92E6-A1ADB629BB11")
    public static let messageContentCharacteristicUUID = CBUUID(string: "27109523-3F45-4961-B9F9-749C793E4CCB")
    public static let messageSenderCharacteristicUUID = CBUUID(string: "A616EBB6-96AE-408E-9A09-6332DCA907AF")
    public static let genericPayloadUUID = CBUUID(string: "B7D9B886-093A-4A8F-A330-CADCA54E600A")
}

class MessagingManager: NSObject {
    let queue = DispatchQueue(label: "org.nameghino.messaging-manager.\(type(of: self))")
}

struct Message: Codable {
    let body: String
    let createdOn = Date()
    let source: String
}
