//
//  ViewController.swift
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

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var targetStringTextField: NSTextField!
    @IBOutlet weak var generationsBestFit: NSTextFieldCell!
    
    @IBAction func go(_ sender: NSButtonCell) {
        run()
    }
    let populationSize = 200
    var population = [DNA]()
    var ancestorPopulation = [DNA]()

    override func viewDidLoad() {
        super.viewDidLoad()
        targetStringTextField.stringValue = "The quick brown fox jumps over the lazy dog"
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func run() {
        let string = targetStringTextField.stringValue
        population = [DNA]()
        ancestorPopulation = [DNA]()
        for _ in 0 ..< populationSize {
            population.append(DNA(numCharacters: string.characters.count))
            ancestorPopulation.append(DNA(numCharacters: string.characters.count))
        }
        
        let geneticAlgorithm = GeneticAlgorithm(targetStringTextField.stringValue)
        
        var k = 0
        var bestFit: String = ""
        while bestFit != string && k < 10000 {
            geneticAlgorithm.createNextGeneration(population: population, ancestorPopulation: ancestorPopulation)
            bestFit = geneticAlgorithm.analyzeGeneration(population: population, ancestorPopulation: &ancestorPopulation)
            k += 1
            print("Generation \(k): \(bestFit)")
        }
    }
}

