//
//  Meal.swift
//  FoodTracker
//
//  Created by Mike Cameron on 2018-05-19.
//  Copyright © 2018 Mike Cameron. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject {
    
    var name: String?
    var photoPath: String?
    var rating: Int?
    var calories: Int?
    var mealDescription: String?
    var id: Int?
    //var userId: Int
    
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK: Initialization
    init?(name: String, rating: Int, calories: Int, mealDescription: String, id: Int) {
        if name.isEmpty || rating < 0 {
            return nil
        }
        self.name = name
        self.rating = rating
        self.calories = calories
        self.mealDescription = mealDescription
        self.id = id
    }
    
    //MARK: NSCoding
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(name, forKey: PropertyKey.name)
//        aCoder.encode(photo, forKey: PropertyKey.photo)
//        aCoder.encode(rating, forKey: PropertyKey.rating)
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
//            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
//        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
//        self.init(name: name, photo: photo, rating: rating)
//    }
}
