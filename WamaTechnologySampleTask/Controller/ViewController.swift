//
//  ViewController.swift
//  WamaTechnologySampleTask
//
//  Created by Mallikarjuna on 30/12/20.
//  Copyright © 2020 Mallikarjuna. All rights reserved.
//

import UIKit
import CoreData

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
        
        var myAppDelRef = UIApplication.shared.delegate as! AppDelegate
        var objectsManagedContext = myAppDelRef.persistentContainer.viewContext
        var moviesEntityRef = NSEntityDescription.entity(forEntityName: "Movies", in: objectsManagedContext) as! NSEntityDescription
        
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
                                for movie in results {
                                    let movieObj = NSManagedObject(entity: moviesEntityRef, insertInto: objectsManagedContext)
                                    movieObj.setValue(movie.id, forKey: "id")
                                    movieObj.setValue(movie.release_date, forKey: "releaseDate")
                                    movieObj.setValue(movie.title, forKey: "title")
                                    movieObj.setValue(movie.vote_average, forKey: "voteAverage")
                                    
                                    do {
                                        try objectsManagedContext.save()
                                        print("\(movie.title):: Details has been saved into coredata")
                                        
                                    } catch {
                                        
                                    }
                                }
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
    
    func fetchMovieDetailsFromCoreData() {
        
        
        var myAppDelRef = UIApplication.shared.delegate as! AppDelegate
        var objectsManagedContext = myAppDelRef.persistentContainer.viewContext
        var moviesEntityRef = NSEntityDescription.entity(forEntityName: "Movies", in: objectsManagedContext) as! NSEntityDescription
        
        let movieFetchReqObj = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
//        movieFetchReqObj.predicate = NSPredicate(format: "id = %@", id)
        do {
            let storedMovieDetails = try objectsManagedContext.fetch(movieFetchReqObj)
            for oneMovie in storedMovieDetails {
                let finalObject = oneMovie as! NSManagedObject
               print(finalObject.value(forKey: "id"))
                print(finalObject.value(forKey: "title"))
            }
        } catch {
            print("unable to fetch data")
        }
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

