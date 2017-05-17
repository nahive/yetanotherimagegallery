//
//  GalleryViewController.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit
import SnapKit

protocol GalleryViewType: ViewType {
    var presenter: GalleryPresenterType! { get set }
    
    func present(photos: [Photo])
    func present(error: String)
    func presentIndicator()
    func hideIndicator()
}

class GalleryViewController: UIViewController {
    
    private lazy var button: UIButton = {
       let button = UIButton()
        button.setTitle("Click me!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    var presenter: GalleryPresenterType!
    
    // MARK: init
    override func viewDidLoad(){
        super.viewDidLoad()
        setup()
    }
    
    // MARK: setup
    private func setup() {
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .darkGray
    }
    
    private func setupSubviews() {
        view.addSubview(button)
    }
    
    private func setupConstraints() {
        button.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
            make.size.equalTo(100)
        }
    }
    
    // MARK: user actions
    private dynamic func buttonTapped(sender: UIButton) {
        presenter.presentPhoto(at: IndexPath(item: 0, section: 0))
    }
    
    // MARK: helpers
}

// MARK: GalleryViewType
extension GalleryViewController: GalleryViewType {
    func present(photos: [Photo]) {
        
    }
    
    func present(error: String) {
        
    }
    
    func presentIndicator() {
        
    }
    
    func hideIndicator() {
        
    }
}
