//
//  ReachabilityService.swift
//  WeatherCore
//
//  Created by Romain Mullot on 02/02/2019.
//  Copyright © 2019 Romain Mullot. All rights reserved.
//

import Foundation
import CoreTelephony
import UIKit
import Reachability

// MARK: - OnlineMode

public enum OnlineMode: Int {
    case offline = 0
    case onlineSlow = 1
    case online = 2
}

// MARK: - Reachability Manager Delegate

public protocol ReachabilityServiceDelegate: class {
    var onlineMode: OnlineMode {get}
    @MainActor func onlineModeChanged(_ onlineMode: OnlineMode)
}

// MARK: - ReachabilityService

public final class ReachabilityService {

    // MARK: Properties

    public static let sharedInstance = ReachabilityService()

    public private(set) var delegates = MulticastDelegate<ReachabilityServiceDelegate>()

    private var reachability: Reachability?

    private let telephonyInfo = CTTelephonyNetworkInfo()

    private var _onlineMode: OnlineMode = .online

    private(set) var onlineMode: OnlineMode {
        get {
            return _onlineMode
        }

        set {
            _onlineMode = newValue
            self.delegates.invoke { (delegate) in
                Task { @MainActor in
                    delegate.onlineModeChanged(_onlineMode)
                }
            }
        }
    }

    private let changeOperatingModeDelay: Double = 2.0 // in seconds

    private var changeOperatinModeClosure: DispatchQueue.CancellableClosure?

    private init() {
        self.delegates = MulticastDelegate<ReachabilityServiceDelegate>.init(addClosure: { delegate in
            Task { @MainActor in
                delegate.onlineModeChanged(self._onlineMode)
            }
        })
        self.onlineMode = .online
        // Reachability 5.x: the initializer is throwing (no non-throwing `Reachability()`).
        do {
            let reachability = try Reachability()
            self.reachability = reachability
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(ReachabilityService.reachabilityChanged(_:)),
                                                   name: Notification.Name.reachabilityChanged,
                                                   object: reachability)
            try reachability.startNotifier()
        } catch let error {
            print("Unable to create/start Reachability! Error: \(error)")
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ReachabilityService.refreshReachability),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Reachability changed

    @objc func refreshReachability() {
        if let reachability = self.reachability {
            NotificationCenter.default.post(name: Notification.Name.reachabilityChanged, object: reachability)
        }
    }

    @objc func reachabilityChanged(_ note: Notification) {
        guard let noteReachability = note.object as? Reachability, let reachability = self.reachability, reachability === noteReachability else {
            return
        }

        if reachability.connection != .unavailable {
            // handle slow / fast mode here
            if let infos = CTTelephonyNetworkInfo().serviceCurrentRadioAccessTechnology,
               let currentRadioAccessTechnology = infos.values.first {
                switch currentRadioAccessTechnology {
                case CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x,
                CTRadioAccessTechnologyGPRS:
                    // slow mode
                    changeOnlineMode(.onlineSlow)
                default:
                    // fast mode
                    changeOnlineMode(.online)
                }
            } else {
                changeOnlineMode(.online)
            }
        } else {
            changeOnlineMode(.offline)
        }
    }

    func changeOnlineMode(_ onlineMode: OnlineMode) {

        if let closure = changeOperatinModeClosure, let unwrappedClosure = closure {
            unwrappedClosure()
        }

        if onlineMode == .online || onlineMode == .onlineSlow {
            self.onlineMode = onlineMode
        } else {
            changeOperatinModeClosure = DispatchQueue.main.cancellableAsyncAfter(secondsDeadline: changeOperatingModeDelay) {
                self.onlineMode = onlineMode
            }
        }
    }

}
