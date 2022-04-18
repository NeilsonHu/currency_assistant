//
//  ForVisaManager.swift
//  CurrencyAssistant
//
//  Created by neilson on 2022-04-18.
//

import Foundation

class CityModel {
    var name: String = ""
    var dates: [String] = []
    init(_ name: String, _ dates: [String]) {
        self.name = name
        self.dates = dates
    }
}

class ForVisaManager: ObservableObject {

    public let request = FVRequest()
    
    @Published var result: [CityModel] = []
    @Published var isLoading: Bool = false

    init() {
        startRequest()
    }
    
    public func startRequest() {
        Xlog("tryTaskForOnce")
        isLoading = true
        request.startDataRequest(whiteList: ["Ottawa", "Toronto"], { [weak self] rsp in
            self?._processResponse(rsp)
            self?.isLoading = false
        })
    }
}

///
/// private methods
///
extension ForVisaManager {
    
    private func _processResponse(_ rsp: [String: [[String: Any]]]) {
        guard !rsp.isEmpty else {
            result = [CityModel("Ottawa", ["empty"]), CityModel("Toronto", ["empty"])]
            return
        }
        result.removeAll()
        rsp.forEach { (key: String, value: [[String: Any]]) in
            guard !value.isEmpty else {
                result.append(CityModel(key, ["empty"]))
                return
            }
            var ary = [String]()
            value.forEach { dict in
                guard let time = dict["date"] as? String else {
                    return
                }
                ary.append(time)
            }
            if ary.isEmpty {
                ary = ["empty"]
            }
            result.append(CityModel(key, ary))
        }
        if result.isEmpty {
            result = [CityModel("Ottawa", ["empty"]), CityModel("Toronto", ["empty"])]
        }
    }
}
