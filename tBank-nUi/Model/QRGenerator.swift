//
//  QRGenerator.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 13/03/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import Foundation
import UIKit


class QRGenerator {
    var stringToEncode: String = ""
    var stringData: Data?
    //var qrFilter: CIFilter?
    
    required init(stringToEncode: String) {
        self.stringToEncode = stringToEncode
        self.stringData = stringToEncode.data(using: String.Encoding.ascii)
    }
    
    func getQRImage() -> CIImage?{
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil}
        
        qrFilter.setValue(stringData, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return nil}
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        return scaledQrImage
    }
    
}
