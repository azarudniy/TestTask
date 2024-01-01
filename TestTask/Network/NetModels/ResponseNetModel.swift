//
//  ResponseNetModel.swift
//  TestTask
//
//  Created by Александр Зарудний on 30.12.23.
//

import Foundation

struct ResponseNetModel: Decodable {
    let features: [FeatureNetModel]
}

extension ResponseNetModel {
    struct FeatureNetModel: Decodable {
        let properties: PropertiesNetModel
    }
}

extension ResponseNetModel.FeatureNetModel {
    struct PropertiesNetModel: Decodable {
        let event: String
        let effective: Date
        let ends: Date?
        let senderName: String
    }
}
