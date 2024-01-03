//
//  ViewController.swift
//  TestTask
//
//  Created by Александр Зарудний on 30.12.23.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    // MARK: - view model

    private let viewModel = ViewModel()

    // MARK: - cancellables

    private var cancellables = Set<AnyCancellable>()

    // MARK: - gui

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(AlertCell.self, forCellReuseIdentifier: AlertCell.cellId)
        table.dataSource = self
        table.delegate = self
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.constraints()
        self.binding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.initRequest()
    }

    //MARK: - constraints

    private func constraints() {
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    // MARK: - binding

    private func binding() {
        self.viewModel
            .$cells
            .dropFirst()
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &self.cancellables)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellItem = self.viewModel.cells[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(
                withIdentifier: AlertCell.cellId,
                for: indexPath) as? AlertCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setupData(cellItem)
        self.viewModel.imageRequest(id: cellItem.id)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {}
