//
//  ViewController.swift
//  TestATOMP_iOS
//
//  Created by dukim on 1/4/24.
//

import UIKit
import Combine
import SnapKit
import Then

final class ViewController: UIViewController {
    
    let label = UILabel().then {
        $0.text = "test"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpData()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setUpData() {
        Timer.publish(every: 1.0, tolerance: 0.1, on: .main, in: .default)
            .autoconnect()
            .enumerated()
            .sink { [weak self] (i, date) in
                print(i)
                
                if let text = self?.label.text {
                    self?.label.text = text + " " + String(i)
                }
            }
            .store(in: &cancellable)
    }
}

extension Publisher {
    func enumerated() -> AnyPublisher<(Int, Self.Output), Self.Failure> {
        scan(Optional<(Int, Self.Output)>.none) { index, next in
            guard let index else {
                return (0, next)
            }
            return (index.0 + 1, next)
        }
        .map { $0! }
        .eraseToAnyPublisher()
    }
}
