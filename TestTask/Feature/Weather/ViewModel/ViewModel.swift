//
//  ViewModel.swift
//  TestTask
//
//  Created by Александр Зарудний on 30.12.23.
//

import Foundation
import Combine

final class ViewModel {

    // MARK: - property

    private var _responseModel: ResponseNetModel? {
        didSet {
            guard let response = self._responseModel else { return }
            self.cells = response.features.map { .init(model: $0.properties) }
        }
    }

    @Published
    private(set) var cells: [CellItem] = []

    // MARK: - request

    func initRequest() {
        Task { @MainActor in
            do {
                self._responseModel = try await NetworkClient.shared.fetchData(
                    urlPath: "https://api.weather.gov/alerts/active?status=actual&message_type=alert")
            } catch {
            }
        }
    }
}

extension ViewModel {
}

extension ViewModel {
    struct CellItem {
        let eventName: String
        let startDate: String
        let endDate: String
        let source: String
        let duration: String

        init(model: ResponseNetModel.FeatureNetModel.PropertiesNetModel) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            self.eventName = model.event
            self.startDate = formatter.string(from: model.effective)

            let calendar = Calendar.current
            if let ends = model.ends, 
                let days = calendar.dateComponents(
                    [.day], from: model.effective, to: ends).day {
                self.endDate = formatter.string(from: ends)
                self.duration = "\(String(describing: days + 1)) day(s)"
            } else {
                self.endDate = "..."
                self.duration = "processing"
            }
            self.source = model.senderName
        }
    }
}
