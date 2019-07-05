//
//  DriversListViewController.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import CoreLocation

class DriversListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    let refreshControl = UIRefreshControl()
    
    // MARK: - Dependencies
    var disposeBag = DisposeBag()
    var viewModel: DriversListViewModelType?
    
    // MARK: - Initializers
    
    init(viewModel: DriversListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "DriversListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycler
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViews()
        viewModel?.inputs.refreshDrivers.onNext(())
    }
    
    // MARK: - Privates
    
    private func setupViews() {
        title = L10n.DriversList.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.icClose.image,
                                                            style: .plain, target: nil,
                                                            action: nil)
        
        // tableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 94
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.refreshControl = refreshControl
        tableView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        tableView.registerCellWithNib(DriverTableViewCell.self)
    }
    
    private func bindViews() {
        
        guard let viewModel = viewModel else { return }
        
        // Inputs
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: viewModel.inputs.closeList)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refreshDrivers)
            .disposed(by: disposeBag)
        
        // Outputs
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<DriverSectionViewModel>(
            configureCell: { _, tableView, indexPath, viewModel -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(type: DriverTableViewCell.self, indexPath: indexPath)
                cell.viewModel = viewModel
                return cell
            }
        )
        
        viewModel.outputs.itemsViewModel
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.itemsViewModel
            .asDriver(onErrorJustReturn: [])
            .map { !($0.first?.items.isEmpty ?? true) } //isNotEmpty?
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.outputs.errorMessage
            .asDriver(onErrorJustReturn: "")
            .filter { !$0.isEmpty } // only show not empty messages
            .drive(onNext: { [weak self] message in
                self?.showErrorMessage(message)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.cityName
            .asDriver(onErrorJustReturn: "-")
            .map { "Drivers in \($0)" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
    }
    
    private func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: L10n.Alert.Error.title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
