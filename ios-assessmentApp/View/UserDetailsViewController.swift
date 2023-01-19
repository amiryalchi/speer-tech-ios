//
//  UserDetailsViewController.swift
//  ios-assessmentApp
//
//  Created by Amir Yalchi on 2023-01-03.
//

import UIKit
import Foundation

class UserDetailsViewController: UIViewController {



    var gitUser: GitUser?
    private var image: UIImage?

    //-MARK: defining the UI element
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    let usernameText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Username:"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    let nameText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Name:"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    let followersLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("followers", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(followersButtonTapped), for: .touchUpInside)
        return button
    }()

    let followingLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("following", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(followingButtonTapped), for: .touchUpInside)
        return button
    }()

    let followersCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    let followingCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    let usernameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
                

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let gitUser = gitUser else { return }

        usernameLabel.text = gitUser.login
        nameLabel.text = gitUser.name
        descriptionLabel.text = gitUser.description
        followingLabel.setTitle("Following \(gitUser.following ?? 0)", for: .normal)
        followersLabel.setTitle("Followers \(gitUser.followers ?? 0)", for: .normal)

        let callGit = CallGitRESTApi()
        callGit.fetchUserImage(urlString: gitUser.avatar_url ?? "") { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.avatarImageView.image = UIImage(data: image)
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        setUpViews()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))

    }

    @objc func handleBack() {
        print("back button tapped")
            dismiss(animated: true, completion: nil)

    }

    @objc func followersButtonTapped() {
        print("followers button tapped")
        if ((self.gitUser?.followers) != 0) {
            DispatchQueue.main.async {
                
                let followersVC = FollowersTableViewController()
                followersVC.gitUser = self.gitUser
                
                self.navigationController?.pushViewController(followersVC, animated: true)

            }
        } else {
            DispatchQueue.main.async {
                let errorViewController = ErrorViewController()
                let navController = UINavigationController(rootViewController: errorViewController)
                self.present(navController, animated: true, completion: nil)
                
            }
        }

    }

    @objc func followingButtonTapped() {
        print("following button tapped")
        DispatchQueue.main.async {
            
            let followingVC = FollowingTableViewController()
            followingVC.gitUser = self.gitUser
            
            self.navigationController?.pushViewController(followingVC, animated: true)

        }
    }
    
    //-MARK: Setting up the UI elements dynamically by code

    func setUpViews () {
        view.addSubview(avatarImageView)
        view.addSubview(usernameStackView)
        view.addSubview(nameStackView)
        view.addSubview(descriptionLabel)
        view.addSubview(followersLabel)
        view.addSubview(followingLabel)
        view.addSubview(followersCountLabel)
        view.addSubview(followingCountLabel)

        usernameStackView.addArrangedSubview(usernameText)
        usernameStackView.addArrangedSubview(usernameLabel)

        nameStackView.addArrangedSubview(nameText)
        nameStackView.addArrangedSubview(nameLabel)

       



        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            usernameStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            usernameStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameStackView.topAnchor.constraint(equalTo: usernameStackView.bottomAnchor, constant: 20),
            nameStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            followersLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            followersLabel.heightAnchor.constraint(equalToConstant: 50),
            followersLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            followersLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            followingLabel.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 30),
            followingLabel.heightAnchor.constraint(equalToConstant: 50),
            followingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            followingLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            followersCountLabel.topAnchor.constraint(equalTo: followingLabel.bottomAnchor, constant: 30),
            followersCountLabel.heightAnchor.constraint(equalToConstant: 50),
            followersCountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            followersCountLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            followingCountLabel.topAnchor.constraint(equalTo: followersCountLabel.bottomAnchor, constant: 30),
            followingCountLabel.heightAnchor.constraint(equalToConstant: 50),
            followingCountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            followingCountLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        ])
    }


}









    

