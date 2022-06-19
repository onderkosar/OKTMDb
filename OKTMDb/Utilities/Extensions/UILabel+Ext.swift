//
//  UILabel+Ext.swift
//  OKTMDb
//
//  Created by Önder Koşar on 19.06.2022.
//

import UIKit

extension UILabel {
    func setAttributedText(primaryString: String, secondaryString: String) {
        let completeString = "\(primaryString)\(secondaryString)"
        let completeAttributedString = NSMutableAttributedString(
            string: completeString, attributes: [
                .foregroundColor: UIColor.label
            ]
        )
        let secondStringAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel
        ]
        let range = (completeString as NSString).range(of: secondaryString)
        completeAttributedString.addAttributes(secondStringAttribute, range: range)
        self.attributedText = completeAttributedString
    }
}
