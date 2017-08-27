//
//  OutboundMessagingManager.swift
//  RXBTLEMessaging
//
//  Created by Nico Ameghino on 8/27/17.
//  Copyright © 2017 Nico Ameghino. All rights reserved.
//

import Foundation
import CoreBluetooth
import CocoaLumberjack

// Central, scans for peripherals and writes in their messaging characteristic
class OutboundMessagingManager: MessagingManager {
    private var knownClients: [String : Peer] = [:]

    private lazy var centralManager: CBCentralManager = {
        return CBCentralManager(delegate: self, queue: self.queue)
    }()

    private func internal_start() {
        centralManager.scanForPeripherals(withServices: [.messagingServiceUUID], options: nil)
    }

    func start() {
        if centralManager.state == .poweredOn {
            internal_start()
        }
    }
}

extension OutboundMessagingManager: CBCentralManagerDelegate {
    @available(iOS 5.0, *)
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if centralManager.state == .poweredOn {
            internal_start()
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        central.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let peerManager = PeerManager(peripheral)
        let peer = Peer(manager: peerManager)
        peripheral.delegate = peerManager
        knownClients[peer.name] = peer
    }
}

struct Peer {
    let manager: PeerManager
    var peripheral: CBPeripheral { return manager.peripheral }
    var name: String { return peripheral.name ?? "\(peripheral.identifier)" }
}

class PeerManager: MessagingManager {
    let peripheral: CBPeripheral
    init(_ peripheral: CBPeripheral) { self.peripheral = peripheral }
}

extension PeerManager: CBPeripheralDelegate {

}
