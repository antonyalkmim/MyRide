//
//  DriverTableViewCell.swift
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import UIKit

class DriverTableViewCell: UITableViewCell {

    var viewModel: DriverCellViewModel? {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var driverIdentifierLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        // cell with rounded corners
        wrapperView.clipsToBounds = false
        wrapperView.layer.cornerRadius = 12
        wrapperView.backgroundColor = UIColor.white
        wrapperView.layer.borderColor = UIColor.darkGray.cgColor
        wrapperView.layer.borderWidth = 0.1
        backgroundColor = UIColor.clear
        
        // thumb with rounded corners
        thumbImageView.layer.cornerRadius = thumbImageView.bounds.width / 2
        
        // distance label with rounded corners
        distanceLabel.clipsToBounds = true
        distanceLabel.layer.cornerRadius = distanceLabel.bounds.height / 2
    }
    
    private func bindUI() {
        thumbImageView.image        = viewModel?.driverIcon
        vehicleTypeLabel.text       = viewModel?.driverFleetType
        driverIdentifierLabel.text  = viewModel?.identifier
        latitudeLabel.text          = viewModel?.latitudeFormatted
        longitudeLabel.text         = viewModel?.longitudeFormatted
        distanceLabel.text          = viewModel?.distanceFormatted
    }
}
