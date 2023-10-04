//
//  ContentView.swift
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
//   This file outlines the instructions for displaying our data inside this view.
//   Architectural Layer: The user interface (UI) of the app.
//
// -------------------------------------------------------------------------------------------

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Group {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("""
                    Hello, world!
                    Where's the UI?
                    
                    🤷🏼‍♂️
                    """)
                .multilineTextAlignment(.center)
            }
            Spacer()
            Text("""
                Concentrate on
                writing the core logic
                (🧠 of the App)
                and not the UI.
                
                Leave the UI blank for now
                and test the behaviour
                by writing unit tests.
                
                Unit tests
                are how the professionals
                test systems
                they build.
                """)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
