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

    private lazy var leftContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.isUserInteractionEnabled = false
        return stack
    }()

    private lazy var rightContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.isUserInteractionEnabled = false
        return stack
    }()

    private lazy var commonContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.isUserInteractionEnabled = false
        return stack
    }()

    private lazy var eventView: UITextView = {
        let view = UITextView()
        return view
    }()

    private lazy var eventDateView: UITextView = {
        let view = UITextView()
        return view
    }()

    private lazy var sourceView: UITextView = {
        let view = UITextView()
        return view
    }()

    private lazy var durationView: UITextView = {
        let view = UITextView()
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
    }
    
    private func initView() {
        self.leftContainer.addArrangedSubviews([self.eventView, self.sourceView])
        self.rightContainer.addArrangedSubviews([self.eventDateView, self.durationView])
        self.commonContainer.addArrangedSubviews([self.customImageView,
                                                  self.leftContainer,
                                                  self.rightContainer])
        self.contentView.addSubview(self.commonContainer)
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.customImageView.snp.makeConstraints {
            $0.width.height.equalTo(200)
        }

        self.commonContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - setup data

    func setupData(_ item: ViewModel.CellItem) {
        self.eventView.text = item.eventName
        self.eventDateView.text = "\(item.startDate) - \(item.endDate)"
        self.sourceView.text = item.source
        self.durationView.text = item.duration

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
