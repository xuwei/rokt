//
//  RoktTableViewCell.swift
//  rokt-app
//
//  Created by Xuwei Liang on 4/12/21.
//

import Foundation

protocol RoktTableViewModelProtocol {}

protocol RoktTableViewCell {
    func configure(_ viewModel: RoktTableViewModelProtocol, delegate: SeriesItemTableViewCellDelgate?)
}
