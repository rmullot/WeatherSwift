//
//  MutexCounter.swift
//  RMCore
//
//  Created by Romain Mullot on 22/01/2019.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation

public final class MutexCounter {

    private let mutex = DispatchSemaphore(value: 1)

    private var counter: Int = 0

    func getValue() -> Int {
      self.mutexConfig()
      return counter
    }

    func setValue(_ value: Int) {
      self.mutexConfig()
      counter = value
    }

    func increment() {
      self.mutexConfig()
      counter += 1
    }

    func decrement() {
      self.mutexConfig()
      counter -= 1
    }

    func incrementAndGet() -> Int {
      self.mutexConfig()
      counter += 1
      return counter
    }

    func decrementAndGet() -> Int {
      self.mutexConfig()
      counter -= 1
      return counter
    }

    func mutexConfig() {
      defer { mutex.signal() }
      mutex.wait()
    }
}
