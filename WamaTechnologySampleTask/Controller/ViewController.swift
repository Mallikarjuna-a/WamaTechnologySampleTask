//
//  ViewController.swift
//  WamaTechnologySampleTask
//
//  Created by Mallikarjuna on 30/12/20.
//  Copyright © 2020 Mallikarjuna. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

@IBOutlet weak var movieListTableView: UITableView!

var resultsDetails:[ResultsStruct]!

override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    movieListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "abc")
    fetchDataFromServer()
    movieListTableView.delegate = self
    movieListTableView.dataSource = self
    }
    
    func fetchDataFromServer() {
        var URLReqObj = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=8ecf484d3847c4c29b21dbc48449d2a5&language=en-US&page=1")!)
            URLReqObj.httpMethod = "GET"
            URLSession.shared.dataTask(with: URLReqObj) { (dataObtained, connectiondetails, error) in
                DispatchQueue.main.async {
                    if let data = dataObtained {
                        print(data)
                        do {
                            let convertedData = try JSONDecoder().decode(DataStruct.self, from: data)
                            if let results = convertedData.results {
                                self.resultsDetails = results
                                self.movieListTableView.reloadData()
                                }
                            print("data has been converted")
                            } catch {                                                print("unable to convert")
                                    }                        
                    } else if let error = error {
                                print(error.localizedDescription)
                    }
                }
            }.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            resultsDetails?.count ?? 0
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "abc", for: indexPath)
            cell.textLabel?.text = resultsDetails[indexPath.row].title
    //        cell.textLabel?.text = "\(sampleArray[0])"
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let movieDetaisViewContrl = storyboard?.instantiateViewController(identifier: "movieDetaisVCID") as? MovieDetailsViewController {
                movieDetaisViewContrl.perticularMovieDetails = resultsDetails[indexPath.row]
                present(movieDetaisViewContrl, animated: true)
            }
            
        }
}

