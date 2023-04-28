//
//  CallStatus.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 24.03.23.
//

import UIKit

public enum CallStatus {
    case requesting
    case ringing
    case exchangingKeys
    case speaking
    case weakSignalSpeaking
    case ending
}

public enum CallBackground {
    case blueYellow(backgroundColor: UIColor, blobsColors: [UIColor])
    case purpleMagenta(backgroundColor: UIColor, blobsColors: [UIColor])
    case orangeRed(backgroundColor: UIColor, blobsColors: [UIColor])
    
    var description: (backgroundColor: UIColor, blobColors: [UIColor]) {
        switch self {
        case let .blueYellow(backgroundColor, blobsColors):
            return (backgroundColor, blobsColors)
        case let .orangeRed(backgroundColor, blobsColors):
            return (backgroundColor, blobsColors)
        case let .purpleMagenta(backgroundColor, blobsColors):
            return (backgroundColor, blobsColors)
        }
    }
}

public enum CallStatusType {
    case text(String)
    case network
}

public struct ConfigurationParameters {
    let background: CallBackground
    let statusText: CallStatusType
    let isWeakToastNeeded: Bool
}
