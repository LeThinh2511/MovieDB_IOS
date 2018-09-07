//
//  ExpandableLabelCell.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/4/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

protocol ExpandableCellDelegate: class {
    func updateTableViewCell()
}

class ExpandableLabelCell: UITableViewCell {

    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var seeMoreButton: UIButton!

    weak var delegate: ExpandableCellDelegate?

    @IBAction func didTapSeeMoreButton(_ sender: Any) {
        if biographyLabel.numberOfLines == 0 {
            biographyLabel.numberOfLines = Constant.numLineLabel
            biographyLabel.lineBreakMode = .byTruncatingTail
            seeMoreButton.setTitle(GeneralName.seeMoreTitle, for: .normal)
        } else {
            biographyLabel.numberOfLines = 0
            biographyLabel.lineBreakMode = .byWordWrapping
            seeMoreButton.setTitle(GeneralName.seeLessTitle, for: .normal)
        }
        UIView.animate(withDuration: Constant.durationAnimationTime) {
            self.layoutIfNeeded()
        }
        self.delegate?.updateTableViewCell()
    }
}
