//
//  ViewController.swift
//  DainikBhaskarReadFxn
//
//  Created by Rahul Chopra on 19/04/20.
//  Copyright © 2020 Rahul Chopra. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.recognize()
    }
    
    func recognize() {
        
        
        let url = Bundle.main.url(forResource: "unnamed", withExtension: "jpg")
        let requestHandler = VNImageRequestHandler(url: url!, options: [:])

        let request = VNRecognizeTextRequest { (request, error) in

            guard let observations = request.results as? [VNRecognizedTextObservation]
            else { return }

            for observation in observations {

                let topCandidate: [VNRecognizedText] = observation.topCandidates(1)

                if let recognizedText: VNRecognizedText = topCandidate.first {
                   // label.text = recognizedText.string
                    print(recognizedText.string)
                }
            }
        }
        
        request.recognitionLevel = .fast
        try? requestHandler.perform([request])
        
        self.detectTextHandler(request: request, error: nil)

    }
    
    func startTextDetection() {
        let request = VNRecognizeTextRequest(completionHandler: self.detectTextHandler)
        request.recognitionLevel = .fast
//        self.requests = [request]
    }

    private func detectTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            fatalError("Received invalid observations")
        }
        for lineObservation in observations {
            guard let textLine = lineObservation.topCandidates(1).first else {
                continue
            }

            let words = textLine.string.split{ $0.isWhitespace }.map{ String($0)}
            for word in words {
                if let wordRange = textLine.string.range(of: word) {
                    if let rect = try? textLine.boundingBox(for: wordRange)?.boundingBox {
                         // here you can check if word == textField.text
                         // rect is in image coordinate space, normalized with origin in the bottom left corner
                    }
                }
            }
       }
    }


}

