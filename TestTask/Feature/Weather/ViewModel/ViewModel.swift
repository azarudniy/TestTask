//
//  ViewModel.swift
//  TestTask
//
//  Created by Александр Зарудний on 30.12.23.
//

import Combine
import UIKit

final class ViewModel {

    // MARK: - cache

    private var imageCache = NSCache<NSString, UIImage>()

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
                    urlPath: Self.dataUrlString)
            } catch {
            }
        }
    }

    func imageRequest(id: UUID) {
        guard let cellItem = self.cells.first(where: { $0.id == id }) else { return }
        if let cachedImage = self.imageCache.object(forKey: id.uuidString as NSString) {
            cellItem.imagePublisher.send(cachedImage)
        } else {
            Task { @MainActor in
                do {
                    let image = try await NetworkClient.shared.fetchImage(
                        urlPath: Self.imageUrlString)
                    self.imageCache.setObject(image, forKey: id.uuidString as NSString)
                    cellItem.imagePublisher.send(image)
                } catch {
                }
            }
        }
    }
}

extension ViewModel {
    private static let dataUrlString = "https://api.weather.gov/alerts/active?status=actual&message_type=alert"
    private static let imageUrlString = "https://picsum.photos/1000"
}

extension ViewModel {
    struct CellItem {
        let id: UUID
        let eventName: String
        let startDate: String
        let endDate: String
        let source: String
        let duration: String
        private(set) var imagePublisher: PassthroughSubject<UIImage?, Never> = .init()

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
            self.id = .init(uuidString: model.id) ?? .init()
        }
    }
}
