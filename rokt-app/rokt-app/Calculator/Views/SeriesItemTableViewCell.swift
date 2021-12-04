//
//  SeriesItemTableViewCell.swift
//  rokt-app
//
//  Created by Xuwei Liang on 4/12/21.
//

import UIKit

protocol SeriesItemTableViewCellDelgate: AnyObject {
    func deleteItemFromSeries(_ cell: SeriesItemTableViewCell);
}

struct SeriesItemTableViewCellViewModel: RoktTableViewModelProtocol {
    let value: String
    let textColor: UIColor
    let showDeleteButton: Bool
}

final class SeriesItemTableViewCell: UITableViewCell, RoktTableViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    weak var delegate: SeriesItemTableViewCellDelgate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func deleteButtonTap(_ sender: UIButton) {
        delegate?.deleteItemFromSeries(self)
    }
    
    // MARK: - RoktTableViewCell
    func configure(_ viewModel: RoktTableViewModelProtocol, delegate: SeriesItemTableViewCellDelgate? = nil) {
        guard let viewModel = viewModel as? SeriesItemTableViewCellViewModel else { return }
        valueLabel.text = viewModel.value
        valueLabel.textColor = viewModel.textColor
        deleteButton.isHidden = !viewModel.showDeleteButton
    }
}
