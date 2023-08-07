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
            background: .purpleMagenta(
                backgroundColor: Color.current.calls.background.purpleColor,
                blobsColors: Color.current.calls.blobs.bluePurpleColors
            ),
            statusText: .text(Texts.statusRequesting),
            isWeakToastNeeded: false,
            isRateCallNeeded: false
        )
    }
    
    func configurationForRinging() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .purpleMagenta(
                backgroundColor: Color.current.calls.background.purpleColor,
                blobsColors: Color.current.calls.blobs.bluePurpleColors
            ),
            statusText: .text(Texts.statusRinging),
            isWeakToastNeeded: false,
            isRateCallNeeded: false
        )
    }
    
    func configurationForExchanging() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .purpleMagenta(
                backgroundColor: Color.current.calls.background.purpleColor,
                blobsColors: Color.current.calls.blobs.bluePurpleColors
            ),
            statusText: .text(Texts.statusExchangingKeys),
            isWeakToastNeeded: false,
            isRateCallNeeded: false
        )
    }
    
    func configurationForSpeaking() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .blueYellow(
                backgroundColor: Color.current.calls.background.greenColor,
                blobsColors: Color.current.calls.blobs.blueYellowColors
            ),
            statusText: .network,
            isWeakToastNeeded: false,
            isRateCallNeeded: false
        )
    }
    
    func configationForWeakSignalRinging() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .orangeRed(
                backgroundColor: Color.current.calls.background.orangeColor,
                blobsColors: Color.current.calls.blobs.pinkColors
            ),
            statusText: .network,
            isWeakToastNeeded: true,
            isRateCallNeeded: false
        )
    }
    
    func configationForEnding() -> ConfigurationParameters {
        ConfigurationParameters(
            background: .purpleMagenta(
                backgroundColor: Color.current.calls.background.purpleColor,
                blobsColors: Color.current.calls.blobs.bluePurpleColors
            ),
            statusText: .network,
            isWeakToastNeeded: false,
            isRateCallNeeded: true
        )
    }
}
