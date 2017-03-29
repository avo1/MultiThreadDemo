//
//  FibonacciEntry.swift
//  MultiThreadsDemo
//
//  Created by Dave Vo on 3/27/17.
//  Copyright © 2017 DaveVo. All rights reserved.
//

import Foundation

class FibonacciEntry {
    var number: Int
    var result: Int?
    
    init (number: Int) {
        self.number = number
    }
    
    func calculate() -> Int {
        var a = 0, b = 1, c = 1
        for _ in 0..<number {
            c = a + b
            a = b
            b = c
        }
        return c
    }
}
