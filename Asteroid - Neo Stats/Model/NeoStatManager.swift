//
//  NeoStatManager.swift
//  Asteroid - Neo Stats
//
//  Created by Ashish Kheveria on 23/07/21.
//

import Foundation

protocol NeoStatManagerDelegate {
    func didUpdateStat(_ statManager: NeoStatManager, stat: [NeoStatModel])
}

struct NeoStatManager {
    
    
    var delegate: NeoStatManagerDelegate?
    
    let neoStatBaseURL = "https://api.nasa.gov/neo/rest/v1/feed?"
    
    
    func fetchDetails(initialDate: String, finalDate: String) {
        let urlString = "\(neoStatBaseURL)start_date=\(initialDate)&end_date=\(finalDate)&api_key=XljH23cmWOMfjCbXIYb1mSDH3dR3YFlB4WBAZ6Gp"
        performRequest(with: urlString)
        //        print(urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let stat = self.parseJSON(safeData) {
                        self.delegate?.didUpdateStat(self, stat: stat)
//                        print(NeoStatDatesArray.arrayOfIndividualDates)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ statData: Data) -> [NeoStatModel]? {
        let decoder = JSONDecoder()
        do {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(formatter)
            let decodedData = try decoder.decode(NeoStatData.self, from: statData)
            
            var modelArray = [NeoStatModel]()
            var id = ""
            var speed = ""
            var distance = ""
            var size = 0.0
            
            for j in 0..<(NeoStatDatesArray.arrayOfDates.count) {
                
                if let elementsInDate = decodedData.nearEarthObjects[NeoStatDatesArray.arrayOfDates[j]] {
//                    print(elementsInDate.count)
                    
                    NeoStatDatesArray.arrayOfIndividualDates.append(elementsInDate.count)
                    
                    for k in 0..<(elementsInDate.count) {
                        
                        id = (decodedData.nearEarthObjects[NeoStatDatesArray.arrayOfDates[j]]?[k].id)!
                        speed = (decodedData.nearEarthObjects[NeoStatDatesArray.arrayOfDates[j]]?[k].closeApproachData[0].relativeVelocity.kilometersPerHour)!
                        distance = (decodedData.nearEarthObjects[NeoStatDatesArray.arrayOfDates[j]]?[k].closeApproachData[0].missDistance.kilometers)!
                        size = (decodedData.nearEarthObjects[NeoStatDatesArray.arrayOfDates[j]]?[k].estimatedDiameter.kilometers.estimatedDiameterMin)!
                        
                        modelArray.append(NeoStatModel(asteroidID: id, fastest: speed, closest: distance, size: size))
                        //                    print(modelArray.count)
                        
                        continue
                    }
                }
            }
            return modelArray
        } catch {
            print(error)
            return nil
        }
    }
    
}
