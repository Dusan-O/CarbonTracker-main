//
//  CarbonFootprintSessionAF.swift
//  CarbonTracker
//
//  Created by Dusan Orescanin on 11/05/2022.
//

import Foundation
import Alamofire

/// This class is used to call Api and
/// calculate footprints for a given journey.
/// - Note that var session conforms
/// to AlamofireSession protocol for testing purposes.
/// When used in production, session is initialized by
/// default with CarbonFootprintSessionAF, which uses the
/// real Alamofire.
class CarbonFootprintSessionAF {
    static let shared = CarbonFootprintSessionAF()
    var session: AlamofireSession
    
    private static let baseFooprintUrlString = "https://www.carboninterface.com/api/v1/estimates"
    
    init(session: AlamofireSession = CarbonFootprintAFSession()) {
        self.session = session
    }
    
    /// This function fetches carbon footprint based
    /// on provided data encoded as EncodableDataRequest type.
    ///  - Parameter withData : data used to calculate footprint.
    /// - Parameter completion : a closure returning
    /// a result type depending on success/failure.
    func fetchCarbonFootprint(withData encodableData: EncodableDataRequest, completion: @escaping (Result<CarbonFootprintObject, NetworkErrors>) -> Void ) {
        session.request(with: CarbonFootprintSessionAF.baseFooprintUrlString, data: encodableData) { response in
            DispatchQueue.main.async {
                guard let data = response.data, response.error == nil else {
                    print("error or no data")
                    completion(.failure(.noData))
                    return
                }
                guard let response = response.response, response.statusCode == 201 else {
                    print("bad response")
                    completion(.failure(.badResponse))
                    return
                }
                do {
                    let footprint = try JSONDecoder().decode(CarbonFootprintObject.self, from: data)
                    completion(.success(footprint))
                } catch {
                    print("could not decode")
                    completion(.failure(.unableToDecodeResponse))
                }
            }
        }
    }
}
