//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Silviu Nicolae on 21.04.2022.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
