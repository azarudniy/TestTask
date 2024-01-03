//
//  AlertCell.swift
//  TestTask
//
//  Created by Александр Зарудний on 1.01.24.
//

import UIKit
import SnapKit
import Combine

final class AlertCell: UITableViewCell {

    // MARK: - cancellable

    private var cancellables = Set<AnyCancellable>()

    // MARK: - cell id

    static let cellId = "AlertCell"

    // MARK: - gui

    private lazy var verticalContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.spacing = 8
        stack.isUserInteractionEnabled = false
        return stack
    }()

    private lazy var commonContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.isUserInteractionEnabled = false
        return stack
    }()

    private lazy var eventView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        return view
    }()

    private lazy var startDateView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        return view
    }()

    private lazy var endDateView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        return view
    }()

    private lazy var sourceView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        return view
    }()

    private lazy var durationView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        return view
    }()

    private lazy var customImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initView()
    }
    
    private func initView() {
        self.verticalContainer.addArrangedSubviews([
            self.eventView,
            self.startDateView,
            self.endDateView,
            self.durationView,
            self.sourceView
        ])
        self.commonContainer.addArrangedSubviews([self.customImageView,
                                                  self.verticalContainer])
        self.contentView.addSubview(self.commonContainer)
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.customImageView.snp.makeConstraints {
            $0.height.width.equalTo(Self.imageSize)
        }

        self.commonContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - setup data

    func setupData(_ item: ViewModel.CellItem) {
        self.cancellables.removeAll()
        self.eventView.text = item.eventName
        self.startDateView.text = item.startDate
        self.endDateView.text = item.endDate
        self.durationView.text = item.duration
        self.sourceView.text = item.source

        item.imagePublisher
            .sink { [weak self] image in
                self?.customImageView.image = image
            }.store(in: &self.cancellables)
    }

    // MARK: - prepare for reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        self.customImageView.image = nil
    }
}

private extension AlertCell {
    private static let imageSize = 100
}
