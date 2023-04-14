//
//  CallScreenConfigurator.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 24.03.23.
//

import Foundation

public final class CallScreenConfigurator {
    func configurationForRequesting() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .purpleMagenta(backgroundColor: Colors.thirdBackgroundColor, blobsColors: Colors.thirdBlobsColors),
            statusText: .text(Texts.statusRequesting),
            isWeakToastNeeded: false
        )
    }
    
    func configurationForRinging() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .purpleMagenta(backgroundColor: Colors.thirdBackgroundColor, blobsColors: Colors.thirdBlobsColors),
            statusText: .text(Texts.statusRinging),
            isWeakToastNeeded: false
        )
    }
    
    func configurationForExchanging() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .purpleMagenta(backgroundColor: Colors.thirdBackgroundColor, blobsColors: Colors.thirdBlobsColors),
            statusText: .text(Texts.statusExchangingKeys),
            isWeakToastNeeded: false
        )
    }
    
    func configurationForSpeaking() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .blueYellow(backgroundColor: Colors.firstBackgroundColor, blobsColors: Colors.firstBlobColors),
            statusText: .network,
            isWeakToastNeeded: false
        )
    }
    
    func configationForWeakSignalRinging() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .orangeRed(backgroundColor: Colors.secondBackgroundColor, blobsColors: Colors.secondBlobsColors),
            statusText: .network,
            isWeakToastNeeded: true
        )
    }
    
    func configationForEnding() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .purpleMagenta(backgroundColor: Colors.thirdBackgroundColor, blobsColors: Colors.thirdBlobsColors),
            statusText: .network,
            isWeakToastNeeded: false
        )
    }
}
