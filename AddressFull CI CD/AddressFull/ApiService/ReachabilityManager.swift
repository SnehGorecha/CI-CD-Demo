//
//  ReachabilityManager.swift
//  IdeoBooks
//
//  Created by Akshat Gandhi on 22/10/21.
//

import UIKit
import Reachability

/// Protocol for listenig network status change
public protocol NetworkStatusListener : AnyObject {
    func networkStatusDidChange(status: Reachability.Connection)
}

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    
    var isNetworkAvailable : Bool {
        let reachability = try! Reachability()
        return reachability.connection != .unavailable
    }
    
    var reachabilityStatus: Reachability.Connection = .unavailable
    
    let reachability = try! Reachability(hostname: "https://www.google.com/m")
    
    var listeners = [NetworkStatusListener]()
    
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .unavailable:
            reachabilityStatus = .unavailable
            debugPrint("Network became unreachable")
        case .wifi:
            reachabilityStatus = .wifi
            debugPrint("Network reachable through WiFi")
        case .cellular:
            reachabilityStatus = .cellular
            debugPrint("Network reachable through Cellular Data")
        case .none:
            debugPrint("Network became unreachable")
        }
        
        // Sending message to each of the delegates
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.connection)
        }
    }
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
    /// Adds a new listener to the listeners array
    ///
    /// - parameter delegate: a new listener
    func addListener(listener: NetworkStatusListener) {
        listeners.append(listener)
    }
    
    /// Removes a listener from listeners array
    ///
    /// - parameter delegate: the listener which is to be removed
    func removeListener(listener: NetworkStatusListener) {
        listeners = listeners.filter { $0 !== listener}
    }
}
