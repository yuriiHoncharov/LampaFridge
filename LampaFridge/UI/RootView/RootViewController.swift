//
//  RootViewController.swift
//  LampaFrig
//
//  Created by Yurii Honcharov on 01.12.2023.
//

import UIKit

class RootViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupText()
    }

    private func setupText() {
        let attributedTitle = NSMutableAttributedString(string: StringConstants.goToFridge)
        attributedTitle.addAttributesFor(subString: StringConstants.start, color: AssetsConstants.yellowColor)
        titleLabel.attributedText = attributedTitle
    }

    private func moveToAR() {
        let vc = ARSceneViewController.fromStoryboard
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction private func pressStartBotton(_ sender: Any) {
        moveToAR()
    }
}
