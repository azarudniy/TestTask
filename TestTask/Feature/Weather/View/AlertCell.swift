//
//  AlertCell.swift
//  TestTask
//
//  Created by Александр Зарудний on 1.01.24.
//

import UIKit
import SnapKit

final class AlertCell: UITableViewCell {

    // MARK: - cell id

    static let cellId = "AlertCell"

    // MARK: - gui

    private lazy var eventContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.isUserInteractionEnabled = false
        return stack
    }()

    private lazy var sourceContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.isUserInteractionEnabled = false
        return stack
    }()

    private lazy var commonContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
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

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        self.eventContainer.addArrangedSubviews([self.eventView, self.eventDateView])
        self.sourceContainer.addArrangedSubviews([self.sourceView, self.durationView])
        self.commonContainer.addArrangedSubviews([self.eventContainer, self.sourceContainer])
        self.contentView.addSubview(self.commonContainer)
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
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
    }
}
