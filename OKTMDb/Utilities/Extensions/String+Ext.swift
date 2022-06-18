//
//  String+Ext.swift
//  OKTMDb
//
//  Created by Önder Koşar on 19.06.2022.
//

import Foundation

extension String {
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        return dateFormatter.date(from: self) ?? nil
    }
}
