//
//  DateUtils.swift
//  MoviesWhishList
//
//  Created by Jovan on 12/12/2018.
//  Copyright © 2018 Jovan. All rights reserved.
//

import Foundation

final class DateUtils {
    
    static let defaultDatePattern: String = "dd/MM/yyyy"
    private static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = defaultDatePattern
        return formatter
    }()
    
    
    static func date(from dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
    
    static func year(from movie: MovieData) -> Int {
        let calendar = Calendar.current
        if let rDate =  movie.releaseDate, let date = self.date(from: rDate) {
            return calendar.component(.year, from: date)
        } else {
            return calendar.component(.year, from: Date())
        }
    }
}




extension DateFormatter {
    convenience init(pattern: String) {
        self.init()
        self.dateFormat = pattern
    }
}
