//
//  Colors.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 24.03.23.
//

import Foundation
import UIKit

public class Color {
    public class Background {
        public class White {
            public let alpha0: UIColor
            public let alpha16: UIColor
            public let alpha20: UIColor
            public let alpha25: UIColor
            public let alpha28: UIColor
            public let alpha30: UIColor
            public let alpha60: UIColor
            
            public init(
                alpha0: UIColor,
                alpha16: UIColor,
                alpha20: UIColor,
                alpha25: UIColor,
                alpha28: UIColor,
                alpha30: UIColor,
                alpha60: UIColor
            ) {
                self.alpha0 = alpha0
                self.alpha16 = alpha16
                self.alpha20 = alpha20
                self.alpha25 = alpha25
                self.alpha28 = alpha28
                self.alpha30 = alpha30
                self.alpha60 = alpha60
            }
        }
        
        
        public let mainColor: UIColor
        public let whiteColor: UIColor
        public let blackColor: UIColor
        public let lightGrayColor: UIColor
        public let darkGrayColor: UIColor
        public let disableGrayColor: UIColor
        public let blueColor: UIColor
        public let darkBlueColor: UIColor
        public let successColor: UIColor
        public let dangerColor: UIColor
        public let errorColor: UIColor
        public let shadowColor: UIColor
        public let gradientBackgroundFirstColors: [UIColor]
        public let gradientBackgroundSecondColors: [UIColor]
        public let detailsBackgroundColors: [UIColor]
        public let detailsButtonBackgroundColors: [UIColor]
        public let white: White
        
        public init(
            mainColor: UIColor,
            whiteColor: UIColor,
            blackColor: UIColor,
            lightGrayColor: UIColor,
            darkGrayColor: UIColor,
            disableGrayColor: UIColor,
            blueColor: UIColor,
            darkBlueColor: UIColor,
            successColor: UIColor,
            dangerColor: UIColor,
            errorColor: UIColor,
            shadowColor: UIColor,
            gradientBackgroundFirstColors: [UIColor],
            gradientBackgroundSecondColors: [UIColor],
            detailsBackgroundColors: [UIColor],
            detailsButtonBackgroundColors: [UIColor],
            white: White
        ) {
            self.mainColor = mainColor
            self.whiteColor = whiteColor
            self.blackColor = blackColor
            self.lightGrayColor = lightGrayColor
            self.darkGrayColor = darkGrayColor
            self.disableGrayColor = disableGrayColor
            self.blueColor = blueColor
            self.darkBlueColor = darkBlueColor
            self.successColor = successColor
            self.dangerColor = dangerColor
            self.errorColor = errorColor
            self.shadowColor = shadowColor
            self.gradientBackgroundFirstColors = gradientBackgroundFirstColors
            self.gradientBackgroundSecondColors = gradientBackgroundSecondColors
            self.detailsBackgroundColors = detailsBackgroundColors
            self.detailsButtonBackgroundColors = detailsButtonBackgroundColors
            self.white = white
        }
    }
    
    public class Text {
        public let blackColor: UIColor
        public let whiteColor: UIColor
        public let secondaryColor: UIColor
        public let disableSecondaryColor: UIColor
        public let blueColor: UIColor
        public let lightBlueColor: UIColor
        public let lightPurpleColor: UIColor
        public let darkGrayColor: UIColor
        public let noticeColor: UIColor
        
        public init(
            blackColor: UIColor,
            whiteColor: UIColor,
            secondaryColor: UIColor,
            disableSecondaryColor: UIColor,
            blueColor: UIColor,
            lightBlueColor: UIColor,
            lightPurpleColor: UIColor,
            darkGrayColor: UIColor,
            noticeColor: UIColor
        ) {
            self.blackColor = blackColor
            self.whiteColor = whiteColor
            self.secondaryColor = secondaryColor
            self.disableSecondaryColor = disableSecondaryColor
            self.blueColor = blueColor
            self.lightBlueColor = lightBlueColor
            self.lightPurpleColor = lightPurpleColor
            self.darkGrayColor = darkGrayColor
            self.noticeColor = noticeColor
        }
    }
    
    public class Calls {
        public class Background {
            public let greenColor: UIColor
            public let orangeColor: UIColor
            public let purpleColor: UIColor
            
            public init(
                greenColor: UIColor,
                orangeColor: UIColor,
                purpleColor: UIColor
            ) {
                self.greenColor = greenColor
                self.orangeColor = orangeColor
                self.purpleColor = purpleColor
            }
        }
        
        public class Blobs {
            public let blueYellowColors: [UIColor]
            public let pinkColors: [UIColor]
            public let bluePurpleColors: [UIColor]
            
            public init(
                blueYellowColors: [UIColor],
                pinkColors: [UIColor],
                bluePurpleColors: [UIColor]
            ) {
                self.blueYellowColors = blueYellowColors
                self.pinkColors = pinkColors
                self.bluePurpleColors = bluePurpleColors
            }
        }
        
        public let background: Background
        public let blobs: Blobs
        
        public init(
            background: Background,
            blobs: Blobs
        ) {
            self.background = background
            self.blobs = blobs
        }
        
    }
    
    public class Google {
        public let googleColors: [UIColor]
        
        public init(googleColors: [UIColor]) {
            self.googleColors = googleColors
        }
    }
    
    public let background: Background
    public let text: Text
    public let calls: Calls
    public let google: Google
    
    public init(
        background: Background,
        text: Text,
        calls: Calls,
        google: Google
    ) {
        self.background = background
        self.text = text
        self.calls = calls
        self.google = google
    }
}

extension Color {
    static let current = Color(
        background: Background(
            mainColor: UIColor(red: 235 / 255, green: 241 / 255, blue: 245 / 255, alpha: 1),
            whiteColor: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1),
            blackColor: UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1),
            lightGrayColor: UIColor(red: 216 / 255, green: 226 / 255, blue: 235 / 255, alpha: 1),
            darkGrayColor: UIColor(red: 204 / 255, green: 213 / 255, blue: 221 / 255, alpha: 1),
            disableGrayColor: UIColor(red: 208 / 255, green: 220 / 255, blue: 228 / 255, alpha: 1),
            blueColor: UIColor(red: 44 / 255, green: 102 / 255, blue: 189 / 255, alpha: 1),
            darkBlueColor: UIColor(red: 26 / 255, green: 66 / 255, blue: 124 / 255, alpha: 1),
            successColor: UIColor(red: 120 / 255, green: 181 / 255, blue: 119 / 255, alpha: 1),
            dangerColor: UIColor(red: 191 / 255, green: 88 / 255, blue: 88 / 255, alpha: 1),
            errorColor: UIColor(red: 224 / 255, green: 37 / 255, blue: 68 / 255, alpha: 1),
            shadowColor: UIColor(red: 0, green: 31 / 255, blue: 61 / 255, alpha: 0.04),
            gradientBackgroundFirstColors: [
                UIColor(red: 222 / 255, green: 131 / 255, blue: 245 / 255, alpha: 1),
                UIColor(red: 131 / 255, green: 245 / 255, blue: 231 / 255, alpha: 1),
                UIColor(red: 243 / 255, green: 206 / 255, blue: 109 / 255, alpha: 1),
                UIColor(red: 255 / 255, green: 95 / 255, blue: 229 / 255, alpha: 1),
                UIColor(red: 131 / 255, green: 245 / 255, blue: 142 / 255, alpha: 1)
            ],
            gradientBackgroundSecondColors: [
                UIColor(red: 69 / 255, green: 60 / 255, blue: 171 / 255, alpha: 1),
                UIColor(red: 69 / 255, green: 60 / 255, blue: 171 / 255, alpha: 1),
                UIColor(red: 155 / 255, green: 37 / 255, blue: 94 / 255, alpha: 1),
                UIColor(red: 46 / 255, green: 198 / 255, blue: 219 / 255, alpha: 1),
                UIColor(red: 60 / 255, green: 138 / 255, blue: 171 / 255, alpha: 1)
            ],
            detailsBackgroundColors: [
                UIColor(red: 97 / 255, green: 49 / 255, blue: 175 / 255, alpha: 1),
                UIColor(red: 51 / 255, green: 94 / 255, blue: 163 / 255, alpha: 1),
                UIColor(red: 167 / 255, green: 70 / 255, blue: 75 / 255, alpha: 1),
                UIColor(red: 46 / 255, green: 113 / 255, blue: 176 / 255, alpha: 1),
                UIColor(red: 52 / 255, green: 155 / 255, blue: 136 / 255, alpha: 1)
            ],
            detailsButtonBackgroundColors: [
                UIColor(red: 68 / 255, green: 35 / 255, blue: 121 / 255, alpha: 1),
                UIColor(red: 35 / 255, green: 76 / 255, blue: 141 / 255, alpha: 1),
                UIColor(red: 150 / 255, green: 49 / 255, blue: 55 / 255, alpha: 1),
                UIColor(red: 36 / 255, green: 83 / 255, blue: 126 / 255, alpha: 1),
                UIColor(red: 27 / 255, green: 121 / 255, blue: 104 / 255, alpha: 1)
            ],
            white: Background.White(
                alpha0: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0),
                alpha16: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.16),
                alpha20: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.2),
                alpha25: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.25),
                alpha28: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.28),
                alpha30: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.3),
                alpha60: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.6)
            )
        ),
        text: Text(
            blackColor: UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1),
            whiteColor: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1),
            secondaryColor: UIColor(red: 136 / 255, green: 153 / 255, blue: 168 / 255, alpha: 1),
            disableSecondaryColor: UIColor(red: 12 / 255, green: 38 / 255, blue: 61 / 255, alpha: 0.24),
            blueColor: UIColor(red: 44 / 255, green: 102 / 255, blue: 189 / 255, alpha: 1),
            lightBlueColor: UIColor(red: 0 / 255, green: 143 / 255, blue: 219 / 255, alpha: 1),
            lightPurpleColor: UIColor(red: 170 / 255, green: 126 / 255, blue: 225 / 255, alpha: 1),
            darkGrayColor: UIColor(red: 46 / 255, green: 46 / 255, blue: 46 / 255, alpha: 1),
            noticeColor: UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
        ),
        calls: Calls(
            background: Calls.Background(
                greenColor: UIColor(red: 87 / 255, green: 158 / 255, blue: 135 / 255, alpha: 1),
                orangeColor: UIColor(red: 229 / 255, green: 129 / 255, blue: 105 / 255, alpha: 1),
                purpleColor: UIColor(red: 116 / 255, green: 110 / 255, blue: 215 / 255, alpha: 1)
            ),
            blobs: Calls.Blobs(
                blueYellowColors: [
                    UIColor(red: 81 / 255, green: 163 / 255, blue: 207 / 255, alpha: 1),
                    UIColor(red: 173 / 255, green: 189 / 255, blue: 101 / 255, alpha: 1)
                ],
                pinkColors: [
                    UIColor(red: 192 / 255, green: 79 / 255, blue: 141 / 255, alpha: 1),
                    UIColor(red: 207 / 255, green: 81 / 255, blue: 128 / 255, alpha: 1)
                ],
                bluePurpleColors: [
                    UIColor(red: 165 / 255, green: 103 / 255, blue: 213 / 255, alpha: 1),
                    UIColor(red: 86 / 255, green: 145 / 255, blue: 214 / 255, alpha: 1)
                ]
            )
        ),
        google: Google(
            googleColors: [
                UIColor(red: 73 / 255, green: 139 / 255, blue: 235 / 255, alpha: 1),
                UIColor(red: 63 / 255, green: 187 / 255, blue: 89 / 255, alpha: 1),
                UIColor(red: 232 / 255, green: 182 / 255, blue: 1 / 255, alpha: 1),
                UIColor(red: 209 / 255, green: 52 / 255, blue: 43 / 255, alpha: 1),
                UIColor(red: 73 / 255, green: 139 / 255, blue: 235 / 255, alpha: 1)
            ]
        )
    )
}
