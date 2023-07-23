//
//  EmojiHelper.swift
//  IdentityInsight
//
//  Created by Paul on 23.07.23.
//

func emojiFlag(for countryCode: String) -> String {
    let base: UInt32 = 127397
    var flagString = ""
    countryCode.uppercased().unicodeScalars.forEach {
        if let scalar = UnicodeScalar(base + $0.value) {
            flagString.append(String(scalar))
        }
    }
    return flagString
}

