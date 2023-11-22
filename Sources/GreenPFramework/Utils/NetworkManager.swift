//
//  NetworkManager.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        let sessionManager = Session(configuration: configuration, interceptor: APIInterceptor())
        return sessionManager
    }()
    
    func request<T: Decodable>(subURL: String, params: Parameters? = nil, method: HTTPMethod) async throws -> T {
        let url = "http://\(HOME_URL)/\(subURL)"
        let request = sessionManager.request(url,
                                             method: method,
                                             parameters: params,
                                             encoding: method == .post ? JSONEncoding.default : URLEncoding.queryString)
            .validate(statusCode: 200..<300)
        let response: DataResponse<T, AFError> = await request.serializingDecodable(T.self).response
        switch response.result {
        case .success(let value):
            print(value)
            return value
        case .failure(let error):
            throw error
        }
    }
}

final class APIInterceptor: RequestInterceptor {
    let retryLimit = 3
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        session.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach {
                if isEqual(task: $0, request: urlRequest) {
                    print("\(urlRequest.url?.absoluteString ?? "") canceled")
                    $0.cancel()
                }
            }
            completion(.success(urlRequest))
        }
        
        /// 완전히 동일한 request인지 확인하는 함수.
        func isEqual(task: URLSessionDataTask, request: URLRequest) -> Bool {
            guard let originalURL = task.originalRequest?.url?.absoluteString,
                  let newURL = urlRequest.url?.absoluteString else {
                return false
            }
            return originalURL == newURL
        }
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let status = request.response?.statusCode {
            if status == 401 {
                completion(.doNotRetry)
            }
        }
        if request.retryCount < retryLimit {
            let timeDelay: TimeInterval = 0.2
            completion(.retryWithDelay(timeDelay))
        } else {
            completion(.doNotRetry)
        }
    }
}
