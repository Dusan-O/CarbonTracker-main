//
//  CarMakeServiceAF.swift
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
/// default with RecipeSession, which uses the
/// real Alamofire.
class CarMakeServiceAF {
    static let shared = CarMakeServiceAF()
    var session: AlamofireSession
    
    private static let baseCarMakesURLString = "https://www.carboninterface.com/api/v1/vehicle_makes"
    
    
    init(session: AlamofireSession = CarbonSession()) {
        self.session = session
    }
    
    /// This function fetches car makes.
    /// - Parameter completion : a closure returning
    /// a result type depending on success/failure
    func fetchCarMakes(completion: @escaping (Result<[CarMakesData], NetworkErrors>) -> Void) {
        session.request(with: CarMakeServiceAF.baseCarMakesURLString, data: nil) { response in
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
                    let carMakes = try JSONDecoder().decode([CarMakesData].self, from: data)
                    let sortedCarMakes = carMakes.sorted { firstCar, secondCar in
                        return firstCar.data.attributes.name < secondCar.data.attributes.name
                    }
                    completion(.success(sortedCarMakes))
                } catch {
                    print("could not decode")
                    completion(.failure(.unableToDecodeResponse))
                }
            }
        }
    }

}
