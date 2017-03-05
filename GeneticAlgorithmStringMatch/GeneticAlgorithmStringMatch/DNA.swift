//
//  DNA.swift
//  GeneticAlgorithmStringMatch
//
//  Created by Joel Middendorf on 2/19/17.
//  Copyright © 2017 Joel Middendorf. All rights reserved.
//
//  Uses a genetic algorithm to match a string seeded with a population
//  of random strings.
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

import Foundation

class DNA {

    var stringSequence: String = ""
    
    init(numCharacters: Int) {
        // Generate the random string numCharacters long
        for _ in 0 ..< numCharacters {
            let randomPrintableAsciiCharacter = Character(UnicodeScalar(32 + arc4random_uniform(127-32))!)
            stringSequence += String(randomPrintableAsciiCharacter)
        }
    }
    
    init(_ inheritedString: String) {
        stringSequence = inheritedString
    }
}
