//
//  CallGitRESTApi.swift
//  ios-assessmentApp
//
//  Created by Amir Yalchi on 2023-01-03.
//

import Foundation

class CallGitRESTApi {


    func fetchGitUser(username: String, completion: @escaping (Result<GitUser, Error>) -> Void) {

        let urlString = "https://api.github.com/users/\(username)"
        guard let url = URL(string: urlString) else { 
            print("URL is not valid")
            return
             }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let gitUser = try JSONDecoder().decode(GitUser.self, from: data)
                completion(.success(gitUser))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        task.resume()
    }

    func fetchUserImage (urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }
        task.resume()
    }

    func fetchUserFollowers (username: String, page: Int, completion: @escaping (Result<[GitUser], Error>) -> Void) {
        let urlString = "https://api.github.com/users/\(username)/followers?page=\(page)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let followers = try JSONDecoder().decode([GitUser].self, from: data)
                completion(.success(followers))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        task.resume()
    }

    func fetchUserFollowing (username: String, page: Int, completion: @escaping (Result<[GitUser], Error>) -> Void) {
        let urlString = "https://api.github.com/users/\(username)/following?page=\(page)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let followings = try JSONDecoder().decode([GitUser].self, from: data)
                completion(.success(followings))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        task.resume()
    }
}