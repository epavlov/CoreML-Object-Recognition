//
//  ViewController.swift
//  CoreML-Object-Recognition
//
//  Created by Eugene Pavlov on 6/9/17.
//  Copyright © 2017 Eugene Pavlov. All rights reserved.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    
    // MARK: - Properties
    let imagePicker = UIImagePickerController()
    let imageModel = Inceptionv3()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesture recognizer to imageView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImageBtnTap(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        imagePicker.delegate = self
    }
    
    @IBAction func chooseImageBtnTap(_ sender: Any) {
        // Present image picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    /**
     Function to to fire after user selects image on device
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = img
            imageView.contentMode = .scaleAspectFit
            processImage()
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func processImage() {
        // Create imageRecognizer object, pass model to it and run recognition on selected image
        let imageRecognizer = ImageRecognizer(model: self.imageModel.model)
        if let image = self.imageView.image?.cgImage {
            // Run recongition
            imageRecognizer.runOn(image: image)
            
            // Get top 1 (strongest) result and display it to user
            let result = imageRecognizer.topResults(1)
            let confidenceInPercents = String(format: "%.2f", result[0].confidence * 100)
            self.predictionLabel.text = "Object on image is: \n \(result[0].identifier) \n Confidence: \n \(confidenceInPercents)%"
        }
        
    }
}

