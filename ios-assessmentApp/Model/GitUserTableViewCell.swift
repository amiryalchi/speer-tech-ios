//
//  GitUserTableViewCell.swift
//  ios-assessmentApp
//
//  Created by Amir Yalchi on 2023-01-03.
//

import UIKit

class GitUserTableViewCell: UITableViewCell {

    var title: String? {
        didSet {
            usernameLabel.text = title
        }
    }
    
    var image: UIImage? {
        didSet {
            userImageView.image = image
        }
    }
    
//-MARK: defining the UI elements
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//-MARK: Setting up the UI elements dynamically by code
    
    func setUpViews() {
        addSubview(usernameLabel)
        addSubview(userImageView)

        NSLayoutConstraint.activate([

            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            
            usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 20)

        ])

    }

}
