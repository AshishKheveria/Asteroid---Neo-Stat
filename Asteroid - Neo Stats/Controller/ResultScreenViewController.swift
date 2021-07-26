//
//  ResultScreenViewController.swift
//  Asteroid - Neo Stats
//
//  Created by Ashish Kheveria on 23/07/21.
//
import Charts
import UIKit

class ResultScreenViewController: UIViewController, ChartViewDelegate {
    
    var barChart = BarChartView()
    
    @IBOutlet weak var fastestIdLabel: UILabel!
    @IBOutlet weak var fastestSpeedLabel: UILabel!
    @IBOutlet weak var fastestSizeLabel: UILabel!
    
    
    @IBOutlet weak var closestIdLabel: UILabel!
    @IBOutlet weak var closestDistanceLabel: UILabel!
    @IBOutlet weak var closestSizeLabel: UILabel!
    
    
    var fastestSpeed = 0.0
    var fastestId = ""
    var fastestSize = 0.0
    
    var closestDistance = 0.0
    var closestId = ""
    var closestSize = 0.0
    
    var neoStatManager = NeoStatManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChart.delegate = self
        
        fastestIdLabel.text = fastestId
        fastestSpeedLabel.text = String(fastestSpeed)
        fastestSizeLabel.text = String(fastestSize)
        
        closestIdLabel.text = closestId
        closestDistanceLabel.text = String(closestDistance)
        closestSizeLabel.text = String(closestSize)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x: 27, y: 428, width: 360, height: 360)
        view.addSubview(barChart)
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:NeoStatDatesArray.arrayOfDates)
        barChart.xAxis.granularity = 1
        barChart.xAxis.labelPosition = .bottom
        
        var entries = [BarChartDataEntry]()
        
        for i in 0..<(NeoStatDatesArray.arrayOfDates.count - 1) {
            entries.append(BarChartDataEntry(x: Double(i), y: Double(NeoStatDatesArray.arrayOfIndividualDates[i])))
            //            print(NeoStatDatesArray.arrayOfDates.count)
        }
        //        print(NeoStatDatesArray.arrayOfDates.count)
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
    
}


