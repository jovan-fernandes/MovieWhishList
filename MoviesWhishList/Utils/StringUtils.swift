//
//  StringUtils.swift
//  MoviesWhishList
//
//  Created by Jovan on 13/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation


extension String {
    
    var sanitized: String {
        let validChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890-")
        return self.filter({validChars.contains($0)})
    }
    
}
