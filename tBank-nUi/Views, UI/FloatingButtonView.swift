//
//  FloatingButtonView.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 08/12/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class FloatingButtonView: UIView {
    
    let k_CONTENT_XIB_NAME = "FloatingButtonView"
    @IBOutlet weak var newTransferButton: UIButton!
    @IBOutlet var buttonView: UIView!
    var tappedClosure: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(k_CONTENT_XIB_NAME, owner: self, options: nil)
        buttonView.fixInView(self)
    }

    @IBAction func tappedAction(_ sender: UIButton) {
        tappedClosure?()
    }
    
}
