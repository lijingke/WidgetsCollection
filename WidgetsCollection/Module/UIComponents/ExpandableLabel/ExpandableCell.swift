//
//  ExpandableCell.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/4.
//

import Foundation
import UIKit

class ExpandableCell: UITableViewCell {
    
    @IBOutlet weak var expandableLabel: ExpandableLabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        expandableLabel.collapsed = true
        expandableLabel.text = nil
    }
}
