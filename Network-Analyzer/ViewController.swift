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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIPLabels()
        setupPortLabels()
    }
    
    private func setupIPLabels() {
        
    }
    
    private func setupPortLabels() {
        
    }


}

