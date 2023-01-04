//
//  ViewController.swift
//  ios-assessmentApp
//
//  Created by Amir Yalchi on 2023-01-03.
//

import UIKit

class SearchViewController: UIViewController {

    //-MARK: defining the UI elements
    
    let textInput: UITextField = {
        let textinput = UITextField()
        textinput.translatesAutoresizingMaskIntoConstraints = false
        textinput.placeholder = "Enter a username"
        textinput.backgroundColor = .white
        textinput.layer.cornerRadius = 25
        textinput.layer.borderWidth = 1
        textinput.layer.borderColor = UIColor.black.cgColor
        textinput.textAlignment = .center
        return textinput
    }()

    let SearchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search GutHub.com", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setUpViews()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

    }

    @objc func searchButtonTapped() {
        let callGitRESTApi = CallGitRESTApi()
        let filteredInput = textInput.text!.replacingOccurrences(of: " ", with: "")
        callGitRESTApi.fetchGitUser(username: filteredInput) { (result) in
            switch result {
            case .success(let gitUser):
                print("USER: ",gitUser)
                DispatchQueue.main.async {
                      
                    let userDetailsViewController = UserDetailsViewController()
                    userDetailsViewController.gitUser = gitUser
                    let navController = UINavigationController(rootViewController: userDetailsViewController) 
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true, completion: nil)
                    self.textInput.text = nil


                }
            case .failure(let error):

                print("ERROR: ",error)
                DispatchQueue.main.async {
                    let errorViewController = ErrorViewController()
                    let navController = UINavigationController(rootViewController: errorViewController)
                    self.present(navController, animated: true, completion: nil)
                    self.textInput.text = nil
                    
                }
            }
        }
    }

    //-MARK: Setting up the UI elements dynamically by code

    func setUpViews() {
        view.addSubview(textInput)
        view.addSubview(SearchButton)

        NSLayoutConstraint.activate([
            textInput.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            textInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textInput.heightAnchor.constraint(equalToConstant: 50),

            SearchButton.topAnchor.constraint(equalTo: textInput.bottomAnchor, constant: 40),
            SearchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            SearchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            SearchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }

}

