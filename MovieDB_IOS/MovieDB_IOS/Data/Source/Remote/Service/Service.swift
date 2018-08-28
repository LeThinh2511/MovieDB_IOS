//
//  Service.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 8/13/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift
class Service {

    private var session: URLSession

    static let shared: Service = {
        let session = URLSession(configuration: .default)
        let service = Service(session: session)
        return service
    }()

    private init(session: URLSession) {
        self.session = session
    }

    // Making request and return
    func request<T: Mappable>(request: URLRequest?) -> Observable<T> {
        return Observable.create { observer in
            guard let requestMovieDB = request
            else {
                    observer.onError(RequestMovieDBError.buildRequestError)
                    return Disposables.create()
            }
            self.session.dataTask(with: requestMovieDB, completionHandler: { (data, response, _) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        guard let data = data
                        else {
                            observer.onError(RequestMovieDBError.buildRequestError)
                            return
                        }
                        let json = String(data: data, encoding: .utf8)
                        guard let jsonString = json, let object = T(JSONString: jsonString)
                        else {
                            observer.onError(RequestMovieDBError.buildRequestError)
                            return
                        }
                        observer.onNext(object)
                        observer.onCompleted()
                    }
                    observer.onError(RequestMovieDBError.buildRequestError)
                }
            }).resume()
            return Disposables.create()
        }
    }
}

enum RequestMovieDBError: Error {
    case buildRequestError
}
