//
//  PhotoViewController.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit

protocol PhotoViewType: ViewType {
    var presenter: PhotoPresenterType! { get set }
}

class PhotoViewController: UIViewController {
    
    var presenter: PhotoPresenterType!
    
    private let backgroundView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(recognizer)
        
        return view
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.shadowRadius = 30.0
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private let takenDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private let publishDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(urlTapped))
        label.addGestureRecognizer(recognizer)
        
        return label
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.setTitle("S H A R E", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.addTarget(self, action: #selector(shareButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: init
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setup()
    }
    
    // MARK: setup
    
    private func setup() {
        setupSubviews()
        setupConstraints()
        configure()
    }
    
    private func setupSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(photoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(tagsLabel)
        contentView.addSubview(takenDateLabel)
        contentView.addSubview(publishDateLabel)
        contentView.addSubview(urlLabel)
        contentView.addSubview(shareButton)
    }
    
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView.snp.edges)
            make.width.equalTo(scrollView.snp.width)
        }
        
        photoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(44)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.height.equalTo(contentView.snp.width).offset(32).multipliedBy(0.6)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
        }
        
        tagsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
        }
        
        takenDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagsLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
        }
        
        publishDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(takenDateLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
        }
        
        urlLabel.snp.makeConstraints { (make) in
            make.top.equalTo(publishDateLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.bottom.equalTo(shareButton.snp.top).offset(-16)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
            make.height.equalTo(44)
        }
    }
    
    private func configure() {
        guard let photo = presenter.photo else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        photoImageView.set(url: photo.imageURL)
        titleLabel.text = photo.title ?? "Unavailable"
        descriptionLabel.text = photo.description ?? "Unavailable"
        tagsLabel.text = photo.tags ?? "Unavailable"
        takenDateLabel.text = "Taken \(photo.takenDate?.literal ?? "unknown")"
        publishDateLabel.text = "Uploaded \(photo.publishDate?.ago ?? "unkown time") ago"
        urlLabel.text = photo.url?.absoluteString ?? "Unavailable"
    }
    
    // MARK: user actions
    
    private dynamic func backgroundTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private dynamic func urlTapped() {
        guard let url = presenter.photo.url else { return }
        UIApplication.shared.open(url)
    }
    
    private dynamic func shareButtonTapped(sender: UIImage) {
        guard let image = photoImageView.image else { return }
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: helpers
}

// MARK: PhotoViewType
extension PhotoViewController: PhotoViewType {
    
}
