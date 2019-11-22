//
//  State.swift
//  BStest
//
//  Created by Fabio Codiglioni on 18/11/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation
import Katana


// MARK: - State
struct CounterState: State {
    var counter: Int = 0
}


// MARK: - Actions

struct IncrementCounter: StateUpdater {
    func updateState(_ state: inout CounterState) {
        state.counter += 1
    }
}


struct DecrementCounter: StateUpdater {
    func updateState(_ state: inout CounterState) {
        state.counter -= 1
    }
}


struct SetCounter: StateUpdater {
    let value: Int
    
    func updateState(_ state: inout CounterState) {
        state.counter = value
    }
}


// MARK: - Side effects

struct GenerateRandomNumber: SideEffect {
    func sideEffect(_ context: SideEffectContext<CounterState, DependenciesContainer>) throws {
        context.dependencies.randomGenerator.randint(start: 0, end: 100).then({value in
            context.dispatch(SetCounter(value: value))
        })
    }
}
