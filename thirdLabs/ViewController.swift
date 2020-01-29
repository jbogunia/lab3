//
//  ViewController.swift
//  thirdLabs
//
//  Created by Jakub Bogunia on 17/01/2020.
//  Copyright © 2020 Jakub Bogunia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            print("download '\(downloadTask.response?.suggestedFilename)' complete")
        
            print("Temporary url: \(location.absoluteURL)")
        
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            print(documentsDirectory);
    
        
            do{
                try FileManager.default.copyItem(at: location.absoluteURL, to: documentsDirectory)
            } catch {
                print("Cannot copy, file exists")
            }
    
    }
    
    

    @IBOutlet weak var statusField: UITextField!
    
    var startTime = NSDate()
    
    let urls = [
        URL(string: "https://upload.wikimedia.org/wikipedia/commons/c/ce/Petrus_Christus_-_Portrait_of_a_Young_Woman_-_Google_Art_Project.jpg"),
        URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/36/Quentin_Matsys_-_A_Grotesque_old_woman.jpg"),
        URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/04/Dyck,_Anthony_van_-_Family_Portrait.jpg")
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func downloadButton(_ sender: Any) {
        
        startTime = NSDate()
        let config = URLSessionConfiguration.background(withIdentifier: "pl.edu.agh.kis.bgDownload")
        config.sessionSendsLaunchEvents = true
        config.isDiscretionary = true
        let session = URLSession(configuration: config, delegate: self,delegateQueue: OperationQueue.main)
        
        for image in urls {
            let task = session.downloadTask(with: image!)
            task.resume()
        }

        ///
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownloaded = Int((Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)) * 100);
        
        let finishTime = NSDate()
        
        let startd = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        
        if(percentDownloaded % 10 == 0 && percentDownloaded != 0) {
            // update the percentage label
            DispatchQueue.main.async {
                self.statusField.text = "\(measuredTime) Downloading image nr \(downloadTask.taskIdentifier)  \(percentDownloaded)%"
            }
            
            print("\(measuredTime) Downloading image nr \(downloadTask.taskIdentifier) \(percentDownloaded)%")
        }
    
    }
    
}

