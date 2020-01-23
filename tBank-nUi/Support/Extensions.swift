//
//  Extensions.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 13/10/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func updateBackgroundImage(imageName: String) {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: imageName)
        
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        view.addSubview(imageViewBackground)
        view.sendSubviewToBack(imageViewBackground)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension UITextField {

    public func setText(to newText: String, preservingCursor: Bool) {
        if preservingCursor {
            let cursorPosition = offset(from: beginningOfDocument, to: selectedTextRange!.start) + newText.count - (text?.count ?? 0)
            text = newText
            if let newPosition = self.position(from: beginningOfDocument, offset: cursorPosition) {
                selectedTextRange = textRange(from: newPosition, to: newPosition)
            }
        }
        else {
            text = newText
        }
    }

}

extension String {
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
       let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
       return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
       }.joined().dropFirst())
    }
}

extension String {
    mutating func translateBankAccountNumber() {
        self.insert("-", at: self.index(self.startIndex, offsetBy: 4))
        self.insert("-", at: self.index(self.startIndex, offsetBy: 9))
        self.insert("-", at: self.index(self.startIndex, offsetBy: 14))
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAlertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
