//
//  String+Extension.swift
//  QRCodeApp
//
//  Created by user227716 on 10/14/22.
//

import Foundation

extension String {
    func isBTCAddressValid() -> Bool {
        
        guard !self.isEmpty else {
            return false
        }
        let pattern = "^[13bc1qbc1p][a-km-zA-HJ-NP-Z1-9]{27,34}$"

        let predicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        let result = predicate.evaluate(with: self)

        return result
    }
}
