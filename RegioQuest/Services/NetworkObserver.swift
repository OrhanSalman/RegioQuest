//
//  NetworkObserver.swift
//  RegioQuest
//
//  Created by Orhan Salman on 20.12.22.
//
/*
import Network
import SwiftUI

final class NetworkObserver: ObservableObject {
    
    @Published private(set) var isConnected = false
    @Published private(set) var isCellular = false
    
    private let nwMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue.global()
    
    public func start() {
        nwMonitor.start(queue: workerQueue)
        nwMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.isCellular = path.usesInterfaceType(.cellular)
            }
        }
    }
    
    public func stop() {
        nwMonitor.cancel()
    }
}
*/
