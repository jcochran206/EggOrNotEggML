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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var camerBtn: UIBarButtonItem!
    
    
    var restnetModel = Resnet50()
    var results = [VNClassificationObservation]()
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let image = imageView.image { detectImage(image: image)}
        imagePicker.delegate = self
        
        camerBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        
    }
    
    //functions section
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            detectImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    //Mark process thru image in resnet model thru a request
    func detectImage(image:UIImage) {
        if let model = try? VNCoreMLModel(for: restnetModel.model){
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation] {
                    self.results = Array(results.prefix(20))
                    self.tableView.reloadData()
                    
//                    for egg in results {
//                        print("\(egg.identifier): \(egg.confidence * 50)%")
//                    }
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
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let result = results[indexPath.row]
        let name = result.identifier.prefix(20)
        cell.textLabel?.text = "\(name): \(Int(result.confidence * 100))%"
        return cell
    }

    @IBAction func folderTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
}

