//
//  NetworkManager.swift
//  FoodTracker
//
//  Created by Mike Cameron on 2018-05-21.
//  Copyright © 2018 Mike Cameron. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    //var meals : [Meal] = []
    
    func makeComponents() -> (URLComponents) {
        var myURLComponents = URLComponents()
        myURLComponents.scheme = "https"
        myURLComponents.host = "cloud-tracker.herokuapp.com"
        myURLComponents.path = "/users/me/meals"
        return myURLComponents
    }

    func post(data: [String: AnyObject], toEndpoint: String, completion: (NSData?, NSError?)->(Void)) {
        
        //URL components
        var myURLComponents = self.makeComponents()
        let titleQueryToken = URLQueryItem(name: "title", value: "apple")
        let descriptionQueryToken = URLQueryItem(name: "description", value: "golden yellow")
        let caloriesQueryToken = URLQueryItem(name: "calories", value: "50")
        myURLComponents.queryItems = [titleQueryToken, descriptionQueryToken, caloriesQueryToken]
        
        //url
        let url = myURLComponents.url
        
        //request
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.value(forKey: "token") as! String
        request.addValue(token, forHTTPHeaderField: "token")
        
        //Task and session
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                //success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
            } else {
                //failure
                print("URL Session Task Failed: %@", error!.localizedDescription)
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
        }
    
    
    
    func getMeals(completion: @escaping (Data?, Error?) -> (Void)) -> (Void) {
        //Url components and url
        let myURLComponents = self.makeComponents()
        let url = myURLComponents.url!
        
        //request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.value(forKey: "token") as! String
        request.addValue(token, forHTTPHeaderField: "token")
        
        //task and session
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: request) { (data: Data?, response, error) in
            completion(data, error)
//            if error == nil {
//                // check status code 200
//                // check that data is not nil
//                // call completion with data, error would be nil
//                completion(data, error)
//                //success
//                let statusCode = (response as! HTTPURLResponse).statusCode
//                print("URL Session Task Succeeded: HTTP \(statusCode)")
//                //self.makeMeals(data: data!)
//            } else {
//                //failure
//                print("URL Session task failed: \(error!.localizedDescription)")
//            }
        }
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func makeMeals(data: Data) -> [Meal] {
        var json: Array<Dictionary<String,Any?>>?
        do {
            json = try JSONSerialization.jsonObject(with: data as Data) as? Array<Dictionary<String,Any?>>
        } catch {
            print(#line, error.localizedDescription)
        }
        guard let mealData = json else {
            print("error parsing")
            return []
        }
        var meals: [Meal] = []
        for i in 0..<mealData.count {
    
            let title = mealData[i]["title"] as! String
            let calories = mealData[i]["calories"] as! Int
            let mealDescription = mealData[i]["description"] as! String
            let id = mealData[i]["id"] as! Int
            let rating = mealData[i]["rating"] as! Int
            let photoURL = mealData[i]["imagePath"] as? String
            let meal = Meal(name: title, rating: rating, calories: calories, mealDescription: mealDescription, id: id)!
            meal.photoPath = photoURL
            meals.append(meal)
            }
        return meals
        }
}
