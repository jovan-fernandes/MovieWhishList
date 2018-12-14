//
//  OsUtils.swift
//  MoviesWhishList
//
//  Created by Jovan on 14/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation
import UIKit

final class OsUtils {
    
    
    static func deviceHasNotch() -> Bool {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
    }
}
