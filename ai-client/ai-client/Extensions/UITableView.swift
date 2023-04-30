//
//  UITableView.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import UIKit

extension UITableView {
    func register(_ cells: AnyClass...) {
        cells.forEach { cell in
            let id = String(describing: cell.self)
            self.register(cell, forCellReuseIdentifier: id)
        }
    }
}
