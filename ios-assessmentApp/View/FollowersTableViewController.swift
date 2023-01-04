//
//  FallowersTableViewController.swift
//  ios-assessmentApp
//
//  Created by Amir Yalchi on 2023-01-03.
//

import UIKit

class FollowersTableViewController: UITableViewController {

    var gitUser: GitUser?
    var followers: [GitUser] = []
    var callGitRESTApi = CallGitRESTApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GitUserTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .lightGray
        navigationItem.title = "Followers"
        fetchAllFollowers(pageNumber: 1)

    }

    
    func fetchAllFollowers(pageNumber: Int) {
        guard let username = gitUser?.login else { return }
        
        callGitRESTApi.fetchUserFollowers(username: username, page: pageNumber) { [weak self] result in
            switch result {
            case .success(let followers):
                // GitHub provide maxium 30 objects in every call in avery page. to get all the users we have to go through a loop and call the api in every page.
                
                self?.followers.append(contentsOf: followers)
                if followers.count == 30 {
                    let newPageNumber = pageNumber + 1
                    self?.fetchAllFollowers(pageNumber: newPageNumber)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GitUserTableViewCell
        let follower = followers[indexPath.row]
        cell.title = follower.login
        let callGit = CallGitRESTApi()
        callGit.fetchUserImage(urlString: follower.avatar_url ?? "") { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.image = UIImage(data: image)
                }
            case .failure(let error):
                print(error)
            }
            
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let follower = followers[indexPath.row]
        let callGitRESTApi = CallGitRESTApi()
        callGitRESTApi.fetchGitUser(username: follower.login) { [weak self] result in
           switch result {
           case .success(let gitUser):
               DispatchQueue.main.async {
                   let userDetailsViewController = UserDetailsViewController()
                   userDetailsViewController.gitUser = gitUser
                   let navController = UINavigationController(rootViewController: userDetailsViewController)
                   navController.modalPresentationStyle = .fullScreen
                   self!.present(navController, animated: true, completion: nil)
               }

           case .failure(let error):
               print(error)
           }
       }
    }

}
