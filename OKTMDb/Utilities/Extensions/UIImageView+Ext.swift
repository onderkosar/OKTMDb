//
//  UIImageView+Ext.swift
//  OKTMDb
//
//  Created by Önder Koşar on 19.06.2022.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(with stringValue: String, successCompletion: ((RetrieveImageResult) -> Void)? = nil, failureCompletion: ((KingfisherError) -> Void)? = nil) {
        guard let imageURL = URL(string: stringValue) else { return }
        self.kf.setImage(with: imageURL, placeholder: Images.placeholderImage,  options: [.transition(.fade(0.3)), .cacheOriginalImage], completionHandler:  { (result: Result<RetrieveImageResult, KingfisherError>) in
            switch result {
            case let .failure(error):
                failureCompletion?(error)
            case let .success(imageResult):
                successCompletion?(imageResult)
            }
        })
    }
}
