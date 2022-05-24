//
//  ViewController.swift
//  Network-Analyzer
//
//  Created by Noor Walid on 23/05/2022.
//

import UIKit

class ViewController: UIViewController {

    //MARK: IPv4 & IPv6 IBOutlets
    @IBOutlet weak var ipv4_1: UILabel!
    @IBOutlet weak var ipv4_2: UILabel!
    @IBOutlet weak var ipv4_3: UILabel!
    @IBOutlet weak var ipv6_1: UILabel!
    @IBOutlet weak var ipv6_2: UILabel!
    @IBOutlet weak var ipv6_3: UILabel!
    
    //MARK: Network Speed Labels
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    
    //MARK: Port Labels
    @IBOutlet weak var port21: UILabel!
    @IBOutlet weak var port22: UILabel!
    @IBOutlet weak var port23: UILabel!
    @IBOutlet weak var port25: UILabel!
    @IBOutlet weak var port53: UILabel!
    @IBOutlet weak var port80: UILabel!
    @IBOutlet weak var port110: UILabel!
    @IBOutlet weak var port1433: UILabel!
    @IBOutlet weak var port3389: UILabel!
    @IBOutlet weak var port5900: UILabel!
    
    
    @IBOutlet weak var port115: UILabel!
    @IBOutlet weak var port135: UILabel!
    @IBOutlet weak var port139: UILabel!
    @IBOutlet weak var port143: UILabel!
    @IBOutlet weak var port194: UILabel!
    @IBOutlet weak var port443: UILabel!
    @IBOutlet weak var port445: UILabel!
    @IBOutlet weak var port3306: UILabel!
    @IBOutlet weak var port5632: UILabel!
    
    //MARK: Variables
    typealias speedTestCompletionHandler = (_ megabytesPerSecond: Double? , _ error: Error?) -> Void

    var speedTestCompletionBlock : speedTestCompletionHandler?

    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!
    var bytesReceivedCG: CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimeLabels()
        setupIPLabels()
        setupPortLabels()
        
        checkForSpeedTest()
    }
    
    private func setupTimeLabels() {
        startTimeLabel?.text? = "\(String(round(startTime.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60) - startTime.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60) )))"
        speedLabel?.text? = "\(bytesReceivedCG)";
        endTimeLabel?.text? = "\(String(round(stopTime!.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))))";
    }
    
    private func setupIPLabels() {
        
    }
    
    private func setupPortLabels() {
        
    }
    
    func checkForSpeedTest() {
        testDownloadSpeedWithTimout(timeout: 10.0) { (speed, error) in
        print("Download Speed:", speed ?? "NA")
        print("Speed Test Error:", error ?? "NA")
      }
    }

    func testDownloadSpeedWithTimout(timeout: TimeInterval, withCompletionBlock: @escaping speedTestCompletionHandler) {
        startTime = CFAbsoluteTimeGetCurrent()
        testSpeed()
        stopTime = CFAbsoluteTimeGetCurrent()
    }

    func testSpeed()  {
      let url = URL(string: "https://images.apple.com/v/imac-with-retina/a/images/overview/5k_image.jpg")
      let request = URLRequest(url: url!)
      let session = URLSession.shared
      let startTime = Date()

      let task =  session.dataTask(with: request) { (data, resp, error) in
        guard error == nil && data != nil else{
          print("connection error or data is nill")
          return
        }

        guard resp != nil else{
          print("respons is nill")
          return
        }

        let length  = CGFloat( (resp?.expectedContentLength)!) / 1000000.0
        print(length)
        let elapsed = CGFloat( Date().timeIntervalSince(startTime))
        print("elapsed: \(elapsed)")
        self.bytesReceivedCG = length/elapsed;
        print("Speed: \(length/elapsed) Mb/sec")

      }
      task.resume()
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
      bytesReceived! += data.count
      stopTime = CFAbsoluteTimeGetCurrent()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

      let elapsed = stopTime - startTime

      if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
        speedTestCompletionBlock?(nil, error)
        return
      }

      let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
      speedTestCompletionBlock?(speed, nil)
    }

}

