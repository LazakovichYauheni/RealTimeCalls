//
//  Converter.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 10.08.23.
//

import Foundation
import UIKit

final class Converter {
    static func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? .empty
    }
    
    static func convertBase64StringToImage(imageBase64String: String?) -> UIImage? {
        guard let imageBase64String = imageBase64String else { return nil }
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image
    }
}
