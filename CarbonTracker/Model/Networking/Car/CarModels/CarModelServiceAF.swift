//
//  CarModelServiceAF.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import Alamofire

/// This class is used to call Api and
/// fetch car makes.
/// - Note that var session conforms
/// to AlamofireSession protocol for testing purposes.
/// When used in production, session is initialized by
/// default with CarbonSession, which uses the
/// real Alamofire.
class CarModelServiceAF {
    static let shared = CarModelServiceAF()
    var session: AlamofireSession
    
    private static let baseCarModelsURLString = "https://www.carboninterface.com/api/v1/vehicle_makes/"
    
    
    init(session: AlamofireSession = CarbonSession()) {
        self.session = session
    }
    
    /// This function fetches car models.
    /// - Parameter completion : a closure returning
    /// a result type depending on success/failure
    func fetchCarModels(with carMakeId: String, completion: @escaping (Result<[CarModelDatas], NetworkErrors>) -> Void) {
        let url = getCarModelsURL(carMakeId: carMakeId)
        session.request(with: url, data: nil) { response in
            DispatchQueue.main.async {
                guard let data = response.data, response.error == nil else {
                    print("error or no data")
                    completion(.failure(.noData))
                    return
                }
                guard let response = response.response, response.statusCode == 200 else {
                    print("bad response")
                    completion(.failure(.badResponse))
                    return
                }
                do {
                    let carModels = try JSONDecoder().decode([CarModelDatas].self, from: data)
                    let sortedCarModels = carModels.sorted { firstCar, secondCar in
                        return firstCar.data.attributes.name < secondCar.data.attributes.name
                    }
                    completion(.success(sortedCarModels))
                } catch {
                    print("could not decode")
                    completion(.failure(.unableToDecodeResponse))
                }
            }
        }
    }
    
    /// This functions return an optionnal URL
    /// - Parameter query : A string value
    /// reprensenting ingredients all serated by a comma.
    private func getCarModelsURL(carMakeId: String) -> String {
        let url2ndPart = "\(carMakeId)/vehicle_models"
        let urlAsString = "\(CarModelServiceAF.baseCarModelsURLString)" + "\(url2ndPart)"
        return urlAsString
    }
}
