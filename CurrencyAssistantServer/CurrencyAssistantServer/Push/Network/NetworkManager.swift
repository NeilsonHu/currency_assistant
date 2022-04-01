//
//  NetworkManager.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-03-30.
//

import Foundation

class NetworkManager : NSObject {
    
    public static let shared = NetworkManager()
    public var identity: SecIdentity? {
        didSet {
            let conf = URLSessionConfiguration.ephemeral
            session = URLSession.init(configuration: conf,
                                      delegate: self,
                                      delegateQueue: .main)
        }
    }
    private var session: URLSession?

    /*
     * https://developer.apple.com/documentation/usernotifications
     * /setting_up_a_remote_notification_server
     * /sending_notification_requests_to_apns?language=objc
     */
    public func postWithPayload(_ payload: String,
                                token: String,
                                topic: String?,
                                priority: UInt,
                                collapseID: String?,
                                payloadType: String,
                                sandBox: Bool,
                                exeSuccess: @escaping ([String: Any]?) -> Void,
                                exeFailed: @escaping (String) -> Void) {
        let subUrlString = sandBox ? ".sandbox" : ""
        guard let url = URL(string: "https://api\(subUrlString).push.apple.com/3/device/\(token)") else {
            return
        }
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        request.httpBody = payload.data(using: .utf8)
        if let t = topic, !t.isEmpty {
            request.addValue(t, forHTTPHeaderField: "apns-topic")
        }
        if let c = collapseID, !c.isEmpty {
            request.addValue(c, forHTTPHeaderField: "apns-collapse-id")
        }
        request.addValue(String(priority), forHTTPHeaderField: "apns-priority")
        request.addValue(payloadType, forHTTPHeaderField: "apns-push-type")
        let task = session?.dataTask(with: request,
                                     completionHandler: { (data, response, error) in
            guard error == nil, let r = response as? HTTPURLResponse else {
                exeFailed(error.debugDescription)
                return
            }
            
            var result: [String: Any]?
            if let data = data, !data.isEmpty {
                do {
                    result = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>
                } catch {
                    print("reason:\(error.localizedDescription)")
                    exeFailed(error.localizedDescription)
                    return
                }
            }

            if r.statusCode == 200 {
                exeSuccess(result)
                return
            }
            let reason = result?["reason"] as? String ?? "undefined error"
            print("reason:\(reason)")
            exeFailed(reason)
        })
        task?.resume()
    }
}

extension NetworkManager : URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let id = identity else {
            return
        }
        var cert: SecCertificate?
        SecIdentityCopyCertificate(id, &cert)
        guard let c = cert else {
            return
        }
        let cred = URLCredential.init(identity: id,
                                      certificates: [c],
                                      persistence: .forSession)
        completionHandler(.useCredential, cred)
    }
}
