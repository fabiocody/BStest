//
//  UI.swift
//  BStest
//
//  Created by Fabio Codiglioni on 18/11/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import UIKit
import Katana
import Tempura
import PinLayout


// MARK: - ViewModel

struct CounterViewModel: ViewModelWithState {   // Per ogni schermo c'è una sola view con un ViewModelWithState
    var countDescription: String

    init(state: CounterState) {
        self.countDescription = "\(state.counter)"
    }
}


// MARK: - View

class CounterView: UIView, ViewControllerModellableView {   //

    // subviews
    var counterLabel = UILabel()
    var addButton = UIButton(type: .system)
    var subButton = UIButton(type: .system)
    var randomButton = UIButton(type: .system)

    // interactions
    var didTapAdd: Interaction?
    var didTapSub: Interaction?
    var didTapRandom: Interaction?
    
    @objc func didTapAddFunc() {
        didTapAdd?()
    }

    @objc func didTapSubFunc() {
        didTapSub?()
    }
    
    @objc func didTapRandomFunc() {
        didTapRandom?()
    }

    // setup
    func setup() {      // 1. Assemblaggio della view, chiamata una volta sola
        addButton.addTarget(self, action: #selector(didTapAddFunc), for: .touchUpInside)
        subButton.addTarget(self, action: #selector(didTapSubFunc), for: .touchUpInside)
        randomButton.addTarget(self, action: #selector(didTapRandomFunc), for: .touchUpInside)
        addSubview(counterLabel)
        addSubview(subButton)
        addSubview(addButton)
        addSubview(randomButton)
    }

    // style
    func style() {      // 2. Cosmetics, chiamata una sola volta
        // Per le subview bisogna manualmente chiamare setup e style nel loro init
        backgroundColor = .black
        counterLabel.font = UIFont.systemFont(ofSize: 32 + 16)
        counterLabel.textColor = .white
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.tintColor = .green
        subButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        subButton.tintColor = .red
        randomButton.setTitle("Random", for: .normal)
        randomButton.titleLabel!.font = UIFont.systemFont(ofSize: 24)
    }

    // update
    func update(oldModel: CounterViewModel?) {  // Chiamato ad ogni aggiornamento di stato
        // Se ho subview con dello stato, il padre è responsabile di creare
        // il ViewModel del figlio
        self.counterLabel.text = self.model?.countDescription
        // setNeedsLayout serve per invalidare il precedente layout e richiamare
        // in modo appropriato layoutSubviews (verrà chiamata a circa 60 Hz)
        self.setNeedsLayout()
    }

    // layout
    override func layoutSubviews() {    //
        // Chiamato quando la view principale cambia dimensione
        // Serve per settare i frame delle subviews
        // VEDERE DIFFERENZA TRA FRAME E BOUNDS
        super.layoutSubviews()
        counterLabel.sizeToFit()
        addButton.sizeToFit()
        subButton.sizeToFit()
        randomButton.sizeToFit()
        counterLabel.pin.center()
        addButton.pin.below(of: counterLabel, aligned: .center).marginTop(20).marginLeft(50)
        subButton.pin.below(of: counterLabel, aligned: .center).marginTop(20).marginRight(50)
        randomButton.pin.below(of: counterLabel, aligned: .center).marginTop(70)
    }
}


// MARK: - View Controller

// Ha la responsabilità di passare alla view un nuovo viewmodel a ogni update
class CounterViewController: ViewController<CounterView> {  // Extension of UIViewController
    override func setupInteraction() {
        rootView.didTapAdd = { [unowned self] in
            self.dispatch(IncrementCounter())
        }
        rootView.didTapSub = { [unowned self] in
            self.dispatch(DecrementCounter())
        }
        rootView.didTapRandom = { [unowned self] in
            self.dispatch(GenerateRandomNumber())
        }
    }
}


enum Screen: String {
    case home
}
