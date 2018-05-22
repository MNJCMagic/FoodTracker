//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Mike Cameron on 2018-05-18.
//  Copyright © 2018 Mike Cameron. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?
    var networkManager: NetworkManager?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            //photoImageView.image = meal.photo
            ratingControl.rating = meal.rating!
        }
        updateSaveButtonState()
    }
    //MARK: text field delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    //MARK: image picker delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image but was provided the following: \(info)")
            }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

    //MARK: Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let rating = ratingControl.rating
        let mealDescription = descriptionTextField.text ?? ""
        let calories = Int(caloriesTextField.text!) ?? 0
        meal = Meal(name: name, calories: calories, rating: rating, mealDescription: mealDescription, id: nil)
        saveMeal(meal: meal!) { (error) -> (Void) in
            if error != nil {
                print("error")
            }

            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
            
        }

        
    }
    
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }

    //MARK: Private methods
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    //MARK: save meal
    func saveMeal(meal: Meal, completion: @escaping (Error?)-> (Void)) {
        //let mealArray = [meal]
        self.networkManager!.post(meal: meal, completion: { (data, error) -> (Void) in
            let meal = self.networkManager?.getID(data: data!)
            let id = meal?.id
            let rating = self.ratingControl.rating
            self.networkManager!.adjustRating(rating: rating, id: id!, completion: { (error) -> (Void) in
                if error != nil {
                    //FAIL
                    print("\(error!.localizedDescription)")
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindSegue", sender: nil)
                }
                completion(error)
            })
            
            completion(error)
        })
    }
    
}

