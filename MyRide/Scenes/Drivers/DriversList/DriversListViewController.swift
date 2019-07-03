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
    
    var refreshControl = UIRefreshControl()
    
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
        viewModel?.refreshDrivers.onNext(())
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
        tableView.registerCellWithNib(DriverTableViewCell.self)
        tableView.refreshControl = refreshControl
        tableView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    }
    
    private func bindViews() {
        
        guard let viewModel = viewModel else { return }
        
        // Inputs
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: viewModel.closeList)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshDrivers)
            .disposed(by: disposeBag)
        
        // Outputs
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<DriverSectionViewModel>(
            configureCell: { _, tableView, indexPath, viewModel -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(type: DriverTableViewCell.self, indexPath: indexPath)
                cell.viewModel = viewModel
                return cell
            }
        )
        
        tableView.dataSource = nil
        
        viewModel.itemsViewModel
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
    }
    
}
