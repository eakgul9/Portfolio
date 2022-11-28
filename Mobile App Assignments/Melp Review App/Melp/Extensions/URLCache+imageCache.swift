//
//  URLCache+imageCache.swift
//  Melp
//
//  Created by Evan Steinhoff on 5/4/22.
//

import Foundation

extension URLCache {
    
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
