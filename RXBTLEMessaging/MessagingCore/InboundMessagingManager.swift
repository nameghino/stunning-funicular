//
//  InboundMessagingManager.swift
//  RXBTLEMessaging
//
//  Created by Nico Ameghino on 8/27/17.
//  Copyright © 2017 Nico Ameghino. All rights reserved.
//

import Foundation
import CoreBluetooth
import CocoaLumberjack

// Peripheral, monitors messaging characteristic for updating messages
class InboundMessagingManager: MessagingManager {
    private lazy var peripheralManager: CBPeripheralManager = {
        return CBPeripheralManager(delegate: self, queue: self.queue)
    }()

    private lazy var service: CBMutableService = {
        return self.createService()
    }()

    let advertisingName: String

    init(advertisingName: String) {
        self.advertisingName = advertisingName
    }

    private var onPeripheralManagerDidUpdateStateBlock: ((CBPeripheralManager) -> Void)? = nil

    private func createService() -> CBMutableService {
        DDLogVerbose("[inbound] creating service")
        let service = CBMutableService(type: .messagingServiceUUID, primary: true)

        let generic = CBMutableCharacteristic(type: .genericPayloadUUID, properties: [.write, .read], value: nil, permissions: [.readable, .writeable])
        service.characteristics = [generic]

//        service.characteristics = [.messageContentCharacteristicUUID, .messageSenderCharacteristicUUID, .genericPayloadUUID].map {
//            return CBMutableCharacteristic(type: $0, properties: [.write, .notify], value: nil, permissions: [])
//        }
        return service
    }

    func start() {
        if peripheralManager.state == .poweredOn {
            internal_start()
        }
    }

    private func internal_start() {
        peripheralManager.add(service)
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [service.uuid], CBAdvertisementDataLocalNameKey: advertisingName])
    }
}

extension InboundMessagingManager: CBPeripheralManagerDelegate {
    @available(iOS 6.0, *)
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        DDLogVerbose("[inbound] peripheral manager state is \(peripheral.state.rawValue)")
        if peripheral.state == .poweredOn {
            internal_start()
        }
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            DDLogVerbose("[inbound] error advertising: \(error)")
            return
        }

        DDLogVerbose("[inbound] advertising")
    }
}
