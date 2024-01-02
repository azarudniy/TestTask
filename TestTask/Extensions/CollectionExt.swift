//
//  CollectionExt.swift
//  TestTask
//
//  Created by Александр Зарудний on 2.01.24.
//

import Foundation

extension Collection {

    subscript(safe index: Index) -> Element? {
        self.getBy(index: index)
    }

    func getBy(index: Index) -> Element? {
        self.indices.contains(index) ? self[index] : nil
    }
}
