//
//  GeneticAlgorithm.swift
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

class GeneticAlgorithm {
    
    var targetString = ""
    var mutationRate = 0.9

    init(_ stringValue: String) {
        targetString = stringValue
    }
    
    func mutate(_ stringSequence: String) -> String {
        let characterCount = UInt32(stringSequence.characters.count)
        let randomOffset = arc4random_uniform(characterCount)
        let range = NSRange(location: Int(randomOffset), length: 1 )
        let randomPrintableAsciiCharacter = Character(UnicodeScalar(32 + arc4random_uniform(127-32))!)
        var newSequence: NSString = stringSequence as NSString
        newSequence = newSequence.replacingCharacters(in: range,
                                        with: String(randomPrintableAsciiCharacter)) as NSString
        return newSequence as String
    }
    
    func numCharsCorrect(string: NSString, targetString: NSString) -> Int {
        var numCorrect = 0
        for k in 0 ..< string.length {
            numCorrect += string.character(at: k) == targetString.character(at: k) ? 1 : 0
        }
        return numCorrect
    }
    
    func isMoreFitThanAncestor(_ currentIndex: Int, population: [DNA], ancestorPopulation: [DNA]) -> (isMoreFit: Bool, distance: Int) {
        let parentString = ancestorPopulation[currentIndex].stringSequence
        let childString = population[currentIndex].stringSequence
        let distanceOfParentString = numCharsCorrect(string: parentString as NSString, targetString: targetString as NSString)
        let distanceOfChildString = numCharsCorrect(string: childString as NSString, targetString: targetString as NSString)
        return (distanceOfParentString < distanceOfChildString) ? (true, distanceOfChildString) : (false, distanceOfChildString)
    }
    
    func replaceAncestor(_ currentIndex: Int, population: [DNA], ancestorPopulation: inout [DNA]) {
        //swap the data
        ancestorPopulation[currentIndex].stringSequence = population[currentIndex].stringSequence
    }

    /// Replace each ancestor at index k if and only if that child
    /// is more fit than the ancestor at index k
    ///
    /// - Parameters:
    ///   - population: the descendant population
    ///   - ancestorPopulation: the older generation
    /// - Returns: a printable string of the most fit person
    func analyzeGeneration(population: [DNA], ancestorPopulation: inout [DNA]) -> String {
        var lowestDistanceSoFar = Int.max
        var bestFitIndex = 0
        for currentIndex in 0 ..< population.endIndex {
            let result = isMoreFitThanAncestor(currentIndex, population: population, ancestorPopulation: ancestorPopulation)
            if result.isMoreFit {
                if result.distance < lowestDistanceSoFar {
                    lowestDistanceSoFar = result.distance
                    bestFitIndex = currentIndex
                }
                replaceAncestor(currentIndex, population: population, ancestorPopulation: &ancestorPopulation)
            }
        }
        return ancestorPopulation[bestFitIndex].stringSequence
    }
    
    func createNextGeneration(population: [DNA], ancestorPopulation: [DNA]) {
        for k in 0 ..< population.count {
            reproduce(k, population: population, ancestorPopulation: ancestorPopulation)
        }
    }
    
    func reproduce(_ parentIndex: Int, population: [DNA], ancestorPopulation: [DNA]) {

        /// Crossover (totally random..no mating pool)
        let fatherIndex = Int(arc4random_uniform(UInt32(ancestorPopulation.count)))
        var motherIndex = Int(arc4random_uniform(UInt32(ancestorPopulation.count)))
        
        /// Don't allow for asexual reproduction
        if fatherIndex == motherIndex {
            motherIndex = ancestorPopulation.count - motherIndex - 1
        }

        let fathersStringSequence = ancestorPopulation[fatherIndex].stringSequence
        let randomMotherStr = ancestorPopulation[motherIndex].stringSequence
        
        var index = fathersStringSequence.index(fathersStringSequence.startIndex, offsetBy: fathersStringSequence.characters.count / 2)
        var concatString = fathersStringSequence.substring(to: index)
        
        index = randomMotherStr.index(randomMotherStr.startIndex, offsetBy: randomMotherStr.characters.count / 2)
        concatString += randomMotherStr.substring(from: index)
        
        let newChild = population[parentIndex]
        
        if arc4random_uniform(100) <= UInt32(mutationRate * 100) {
            newChild.stringSequence = mutate(concatString)
        } else {
            newChild.stringSequence = concatString
        }
    }
}
