//
//  FollowingTableViewController.swift
//  ios-assessmentApp
//
//  Created by Amir Yalchi on 2023-01-03.
//

import UIKit

class FollowingTableViewController: UITableViewController {

    var gitUser: GitUser?
    var followingUsers: [GitUser] = []
    var callGitRESTApi = CallGitRESTApi()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GitUserTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        navigationItem.title = "Following"
        tableView.separatorColor = .lightGray
        fetchAllFollowing(pageNumber: 1)
    }

    func fetchAllFollowing(pageNumber: Int) {
        guard let username = gitUser?.login else { return }
        
        callGitRESTApi.fetchUserFollowing(username: username, page: pageNumber) { [weak self] result in
            switch result {
            case .success(let following):
                // GitHub provide maxium 30 objects in every call in avery page. to get all the users we have to go through a loop and call the api in every page.

                self?.followingUsers.append(contentsOf: following)
                if following.count == 30 {
                    let newPageNumber = pageNumber + 1
                    self?.fetchAllFollowing(pageNumber: newPageNumber)
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
        return followingUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GitUserTableViewCell
        let followingUser = followingUsers[indexPath.row]
        cell.title = followingUser.login
        let callGit = CallGitRESTApi()
        callGit.fetchUserImage(urlString: followingUser.avatar_url ?? "") { result in
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
         let following = followingUsers[indexPath.row]
        let callGitRESTApi = CallGitRESTApi()
        callGitRESTApi.fetchGitUser(username: following.login) { [weak self] result in
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
