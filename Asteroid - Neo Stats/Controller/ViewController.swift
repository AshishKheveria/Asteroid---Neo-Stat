//
//  ViewController.swift
//  Asteroid - Neo Stats
//
//  Created by Ashish Kheveria on 23/07/21.
//

import UIKit

class ViewController: UIViewController, NeoStatManagerDelegate {
    
    
    var timer = Timer()
    @IBOutlet weak var initialDate: UIDatePicker!
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var submitButtonState: UIButton!
    @IBOutlet weak var finadDate: UIDatePicker!
    
    var storeInitialDate = ""
    var storeFinalDate = ""
    var initialDateFormat = Date()
    var finalDateFormat = Date()
    
    var neoStatFetchDetails = NeoStatManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButtonState.isEnabled = false
        initialDate.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        finadDate.addTarget(self, action: #selector(finalDatePickerValueChanged), for: .valueChanged)
        neoStatFetchDetails.delegate = self
    }
    
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
        
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        NeoStatDatesArray.arrayOfIndividualDates = [Int]()
        NeoStatDatesArray.arrayOfDates = [String]()
        initialDateFormat = sender.date
        
        submitButtonState.isEnabled = false
        
        storeInitialDate = formatDate(date: sender.date)
        //        NeoStatDetails.initialDate = storeInitialDate
        NeoStatDatesArray.arrayOfDates.append(storeInitialDate)
        //        print(storeInitialDate)
    }
    
    
    
    @IBAction func finalDatePickerValueChanged(_ sender: UIDatePicker) {
        submitButtonState.isEnabled = false
        
        finalDateFormat = sender.date
        storeFinalDate = formatDate(date: sender.date)
        //        NeoStatDetails.finalDate = storeFinalDate
        //        print(storeFinalDate)
        while initialDateFormat <= finalDateFormat {
            
            //            print(NeoStatDatesArray.arrayOfDates)
            
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: initialDateFormat) else {break}
            initialDateFormat = newDate
            NeoStatDatesArray.arrayOfDates.append(formatDate(date: initialDateFormat))
        }
        
        
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        submitButtonState.isEnabled = false
        message.text = "Behold! The Asteroids are crossing. 🤯😍"
        timer.invalidate()
        neoStatFetchDetails.fetchDetails(initialDate: storeInitialDate, finalDate: storeFinalDate)
        
        // When the api is called successfully the submit button will appear then.
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(enableButton), userInfo: nil, repeats: true)
        
    }
    
    @objc func enableButton() {
            
        submitButtonState.isEnabled = true
    }
    
    func didUpdateStat(_ statManager: NeoStatManager, stat: [NeoStatModel]) {
       
        var speedArray = [Double]()
        var distanceArray = [Double]()
        
        for i in 0..<stat.count {
            
            ResultData.fastest = Double(stat[i].fastest)!
            speedArray.append(ResultData.fastest)
            
            ResultData.closest = Double(stat[i].closest)!
            distanceArray.append(ResultData.closest)
            
        }
        
        UpdateFastestAsteroidResult.fastest = speedArray.max()!
        UpdateClosestAsteroidResult.closest = distanceArray.min()!
        
        var indexOfTheMaxSpeed = speedArray.indices.filter { speedArray[$0] == UpdateFastestAsteroidResult.fastest}
        var indexOfTheClosestDistance = distanceArray.indices.filter { distanceArray[$0] == UpdateClosestAsteroidResult.closest}
        
        //        print(indexOfTheMaxSpeed)
        //        print(indexOfTheClosestDistance)
        
        UpdateFastestAsteroidResult.id = stat[indexOfTheMaxSpeed[0]].asteroidID
        UpdateFastestAsteroidResult.size = stat[indexOfTheMaxSpeed[0]].size
        //        print(UpdateFastestAsteroidResult.size)
        
        UpdateClosestAsteroidResult.id = stat[indexOfTheClosestDistance[0]].asteroidID
        UpdateClosestAsteroidResult.size = stat[indexOfTheClosestDistance[0]].size
        //        print(UpdateClosestAsteroidResult.size)
        
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        message.text = ""
        submitButtonState.isEnabled = false
        self.performSegue(withIdentifier: "resultScreen", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        print(fastestId)
        
        if segue.identifier == "resultScreen" {
            
            let destinationVC = segue.destination as! ResultScreenViewController
            destinationVC.fastestId = UpdateFastestAsteroidResult.id
            destinationVC.fastestSize = UpdateClosestAsteroidResult.size
            destinationVC.fastestSpeed = UpdateFastestAsteroidResult.fastest
            
            destinationVC.closestId = UpdateClosestAsteroidResult.id
            destinationVC.closestSize = UpdateClosestAsteroidResult.size
            destinationVC.closestDistance = UpdateClosestAsteroidResult.closest
        }
    }
}
