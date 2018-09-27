//
//  ViewController.swift
//  EggOrNotEggML
//
//  Created by Jonathan Cochran on 9/26/18.
//  Copyright © 2018 Jonathan Cochran. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    var restnetModel = Resnet50()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let image = imageView.image { detectImage(image: image)}
    }
    
    //functions section
    //Mark process thru image in resnet model thru a request
    func detectImage(image:UIImage) {
        if let model = try? VNCoreMLModel(for: restnetModel.model){
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation] {
                    print(results)
                }
            }
            //converts image into data and uses handler
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
            }
        }
            
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "hi"
        return cell
    }


}

