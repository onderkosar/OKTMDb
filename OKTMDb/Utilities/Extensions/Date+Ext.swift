//
//  Date+Ext.swift
//  OKTMDb
//
//  Created by Önder Koşar on 19.06.2022.
//

import Foundation

extension Date {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: self)
    }
}
