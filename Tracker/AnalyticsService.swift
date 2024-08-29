//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Мария Шагина on 29.08.2024.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "a1667df4-11df-4268-b7d7-0ec9a524aad2") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: Events, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
