//
//  Calc123Engine.swift
//  CodingChallengeCalculator
//
//  Created by SwiftSimplified.com on 23/09/2023.
//
//  SwiftSimplified.com             → All rights reserved
//  Website                         → https://www.swiftsimplified.com
//
//  We 🧡 Swift
//  Welcome to our community of Swift Simplified students!
//
//  🧕🏻🙋🏽‍♂️👨🏿‍💼👩🏼‍💼👩🏻‍💻💁🏼‍♀️👨🏼‍💼🙋🏻‍♂️🙋🏻‍♀️👩🏼‍💻🙋🏿💁🏽‍♂️🙋🏽‍♀️🙋🏿‍♀️🧕🏾🙋🏼‍♂️
// -------------------------------------------------------------------------------------------
//
// → What's This File?
//   This file contains the calculator itself, which internally uses an EquationBuilder to
//   build an equation, update the display and handle input through the keypad.
//   Architectural Layer: The business logic layer (the main non-visual system).
//
// -------------------------------------------------------------------------------------------


import Foundation


class Calculator: CalculatorAPI {
    
    // MARK: - Properties
    
    private var equationBuilder: EquationBuilding
    private let equationBuilderProvider: (() -> EquationBuilding)
    
    // MARK: - Display
    
    var lcdDisplayText: String {
        equationBuilder.lcdDisplayText
    }
    
    // MARK: - Properties That Help with Testing
    
    var lhs: Decimal {
        equationBuilder.lhs
    }
    
    var rhs: Decimal? {
        equationBuilder.rhs
    }
    
    var operation: MathOperation? {
        equationBuilder.operation
    }
    
    // MARK: - Initialiser
    
    init(_ equationBuilder: @escaping (() -> EquationBuilding)) {
        self.equationBuilderProvider = equationBuilder
        self.equationBuilder = equationBuilder()
    }
    
    // MARK: - Interaction API
    
    func clearPressed() {
        equationBuilder = equationBuilderProvider()
    }
    
    func negatePressed() {
        populatePreviousResultIfNeeded(true)
        equationBuilder.negate()
    }
    
    func percentagePressed() {
        populatePreviousResultIfNeeded(true)
        equationBuilder.applyPercentage()
    }
    
    func decimalPressed() {
        if equationBuilder.isCompleted {
            equationBuilder = equationBuilderProvider()
        }
        equationBuilder.applyDecimalPoint()
    }
    
    var result: Decimal? {
        equationBuilder.result
    }
    
    // MARK: - Operations
    
    func addPressed() {
        commitAndPopulatePreviousResultIfNeeded()
        equationBuilder.add()
    }
    
    func minusPressed() {
        commitAndPopulatePreviousResultIfNeeded()
        equationBuilder.subtract()
    }
    
    func multiplyPressed() {
        commitAndPopulatePreviousResultIfNeeded()
        equationBuilder.multiply()
    }
    
    func dividePressed() {
        commitAndPopulatePreviousResultIfNeeded()
        equationBuilder.divide()
    }
    
    func equalsPressed() {
        if equationBuilder.isCompleted {
            var newEquationBuilder = equationBuilderProvider()
            newEquationBuilder.lhs = equationBuilder.result ?? Decimal.zero
            newEquationBuilder.operation = equationBuilder.operation
            newEquationBuilder.rhs = equationBuilder.rhs
            equationBuilder = newEquationBuilder
        }
        
        guard equationBuilder.isReadyToExecute else {
            return
        }
        
        executeEquation()
    }
    
    // MARK: - Equation Execution
    
    private func executeEquation() {
        equationBuilder.execute()
        printEquationToDebugConsole(equationBuilder)
    }
    
    // MARK: - Print To Console
    
    private func printEquationToDebugConsole(_ calculatorInput: EquationBuilding) {
        #if DEBUG // don't print in a production environment - it slows down code execution
        print(calculatorInput.generatePrintout)
        #endif
    }
    
    // MARK: - Number Input
    
    func numberPressed(_ number: Int) {
        // → Only accept values from the numeric keypad 0..9
        guard number <= 9,
        number >= 0 else { return }
        
        if equationBuilder.isCompleted {
            equationBuilder = equationBuilderProvider()
        }
        equationBuilder.enterNumber(number)
    }
    
    // MARK: - Business Logic & Behaviour
    
    private func commitCurrentEquationIfNeeded() -> Bool {
        if equationBuilder.isCompleted == false,
           equationBuilder.isReadyToExecute {
            executeEquation()
            return true
        }
        
        return false
    }
    
    private func populateEquationBuilderWithPreviousResult(_ continueEditingResult: Bool = false) {
        var newEquationBuilder = equationBuilderProvider()
        newEquationBuilder.lhs = equationBuilder.result ?? Decimal(0)
        
        if continueEditingResult == false {
            newEquationBuilder.startEditingRightHandSide()
        }
        equationBuilder = newEquationBuilder
    }
    
    private func commitAndPopulatePreviousResultIfNeeded(_ continueEditingResult: Bool = false) {
        
        // → Scenario 1: user enters 5 * 5 *
        if commitCurrentEquationIfNeeded() {
            populateEquationBuilderWithPreviousResult(continueEditingResult)
        }
        
        // → Scenario 2: user enters 5 * 5 = *
        if equationBuilder.isCompleted {
            populateEquationBuilderWithPreviousResult()
        }
    }
    
    private func populatePreviousResultIfNeeded(_ continueEditingResult: Bool = false) {
        if equationBuilder.isCompleted {
            populateEquationBuilderWithPreviousResult(continueEditingResult)
        }
    }
}
