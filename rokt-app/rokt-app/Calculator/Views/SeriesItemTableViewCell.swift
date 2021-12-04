//
//  SeriesItemTableViewCell.swift
//  rokt-app
//
//  Created by Xuwei Liang on 4/12/21.
//

import UIKit

struct SeriesItemTableViewCellViewModel: RoktTableViewModelProtocol {
    let value: String
    let textColor: UIColor
}

final class SeriesItemTableViewCell: UITableViewCell, RoktTableViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - RoktTableViewCell
    func configure(_ viewModel: RoktTableViewModelProtocol) {
        guard let viewModel = viewModel as? SeriesItemTableViewCellViewModel else { return }
        valueLabel.text = viewModel.value
        valueLabel.textColor = viewModel.textColor
    }
}
