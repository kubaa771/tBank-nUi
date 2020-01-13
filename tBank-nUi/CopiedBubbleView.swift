//
//  CopiedBubbleView.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 13/01/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit

class CopiedBubbleView: UIView {
    
    let k_CONTENT_XIB_NAME = "CopiedBubbleView"
    @IBOutlet var bubbleView: UIView!
    
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
        bubbleView.layer.cornerRadius = 15
        bubbleView.fixInView(self)
    }

}
