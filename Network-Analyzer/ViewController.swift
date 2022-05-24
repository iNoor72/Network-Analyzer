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
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    
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

    private var speedTestCompletionBlock : speedTestCompletionHandler?

    private var startTime: CFAbsoluteTime!
    private var stopTime: CFAbsoluteTime!
    private var bytesReceived: Int!
    private var bytesReceivedCG: CGFloat = 0.0
    
    private let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimeLabel.text = "0.0"
        checkForSpeedTest()
        setupTimeLabels()
        setupIPLabels()
        setupPortLabels()
    }
    
    private func setupTimeLabels() {
        startTimeLabel.text = "\(Calendar.current.component(.hour, from: date)):\(Calendar.current.component(.minute, from: date)):\(Calendar.current.component(.second, from: date))"
        
        speedLabel.text = "Calculating..."
        
        elapsedTimeLabel.text = "Calculating..."
    }
    
    private func setupIPLabels() {
        let addr = IPManager.shared.getIFAddresses()
        print(addr)

        let IP6_A = addr[0]
        let IP4_0 = addr[1]
        let IP6_B = addr[2]
        let IP6_C = addr[3]
        let IP6_D = addr[7]
        let IP6_E = addr[5]

        ipv4_1.text?   = IP6_A
        ipv4_2?.text?  = IP4_0
        ipv4_3?.text?  = IP6_B
        ipv6_1?.text?  = IP6_C
        ipv6_2?.text?  = IP6_D
        ipv6_3?.text?  = IP6_E
    }
    
    private func setupPortLabels() {
        if (PortsManager.shared.checkTcpPortForListen(port: 21) == true){
          port21.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 22) == true){
          port22.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 23) == true){
          port23.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 25) == true){
          port25?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 53) == true){
          port53?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 110) == true){
          port110?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 115) == true){
          port115?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 135) == true){
          port135?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 139) == true){
          port139?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 143) == true){
          port143?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 194) == true){
          port194?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 443) == true){
          port443?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 445) == true){
          port445?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 1433) == true){
          port1433?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 3306) == true){
          port3306?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 3389) == true){
          port3389?.textColor = UIColor.green
        }

        if (PortsManager.shared.checkTcpPortForListen(port: 5632) == true){
          port5632?.textColor = UIColor.green
        }

    }
    
    //MARK: Network
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

      let task =  session.dataTask(with: request) {[weak self] (data, resp, error) in
        guard error == nil && data != nil, let self = self else{
          print("connection error or data is nil")
          return
        }

        guard resp != nil else{
          print("response is nill")
          return
        }

        let length  = CGFloat( (resp?.expectedContentLength)!) / 1000000.0
        print(length)
        let elapsed = CGFloat(Date().timeIntervalSince(startTime))
        print("elapsed: \(elapsed)")
          self.bytesReceivedCG = length/elapsed;
        print("Speed: \(length/elapsed) Mb/sec")
          DispatchQueue.main.async {
              self.elapsedTimeLabel.text = "\(elapsed) seconds"
              self.speedLabel.text = "\(self.bytesReceivedCG) MB/sec"
          }

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

    //MARK: IBOutlets
    @IBAction func testNetworkTapped(_ sender: UIButton) {
        checkForSpeedTest()
        setupTimeLabels()
        setupPortLabels()
    }
    
    @IBAction func ipInfoTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Network Analyzer Info", message: "This is our project for CSE439: Wireless Networks course at Ain Shams University. This app was made by the team of Noor, Ahmad, and Kero.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
          switch action.style{
          case .default:
            print("default [OK Pressed]")

          case .cancel:
            print("cancel [CANCEL Pressed]")

          case .destructive:
            print("destructive [Destructive Type: After n seconds]")
          }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func portsInfoTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Ports Available", message: "This section shows the status of different port numbers, these port numbers corresponds for the following: 21 FTP, 22 SSH, 23 TELNET, 25 SMTP, 53 DNS, 80 HTTP, 110 POP3, 115 SFTP, 135 RPC, 139 NetBIOS, 143 IMAP, 194 IRC, 443 SSL, 445 SMB, 1433 MSSQL, 3306 MySQL, 3389 Remote Desktop, 5632 PCAnywhere.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
          switch action.style{
          case .default:
            print("default [OK Pressed]")

          case .cancel:
            print("cancel [CANCEL Pressed]")

          case .destructive:
            print("destructive [Destructive Type: After n seconds]")
          }}))
        self.present(alert, animated: true, completion: nil)
    }
}

