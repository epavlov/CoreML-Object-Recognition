//
//  ImageRecognizer.swift
//  CoreML-Object-Recognition
//
//  Created by Eugene Pavlov on 6/9/17.
//  Copyright © 2017 Eugene Pavlov. All rights reserved.
//

import Foundation
import CoreML
import Vision

class ImageRecognizer {
    private var model: MLModel?
    
    /// Array of results. Each VNClassificationObservation object contains "identifier" as String description of an object on a picture and "confidence" as a Double representation of accuracy.
    var results: [VNClassificationObservation] = []
    
    /// Takes results array, sort it with most confident results on top and returns N ammount of results items requested
    lazy var topResults: (Int) -> [VNClassificationObservation] = {
        (numberOfResultsToReturn) -> [VNClassificationObservation] in
        let sorted: [VNClassificationObservation] = self.results.sorted { $0.confidence > $1.confidence }
        
        return Array(sorted.prefix(numberOfResultsToReturn))
    }
    
    init(model: MLModel) {
        self.model = model
    }
    
    /**
     Function to run image recognition
     
     - parameter image: CGImage from the camera or photo library
     
     - returns: void
     */
    func runOn(image: CGImage) {
        do {
            let model = try VNCoreMLModel(for: self.model!)
            let request = VNCoreMLRequest(model: model, completionHandler: getResults)
            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            try handler.perform([request])
            
        } catch {
            fatalError("Error performing recognition request")
        }
    }
    
    private func getResults(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("Error casting results as array of observation objects")
        }
        self.results = results
    }
}
