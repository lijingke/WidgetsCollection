//
//  ECGModel.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/1/18.
//  Copyright © 2024 李京珂. All rights reserved.
//

import Foundation

enum Classification: Int {
    case notSet = 0

    case sinusRhythm = 1

    case atrialFibrillation = 2

    case inconclusiveLowHeartRate = 3

    case inconclusiveHighHeartRate = 4

    case inconclusivePoorReading = 5

    case inconclusiveOther = 6

    case unrecognized = 100
}

struct ECGModel {
    var ecgData: [Double] = []
    var averageHeartRate: Int?
    var startTimeStamp: Double = 0
    var endTimeStamp: Double = 0
    var sourceDevice: String = "Apple Watch"
    var classification: Int = 0
    var samplingFrequency: Double?
    var numberOfVoltageMeasurements: Int = 0

    var classificationDes: String {
        switch classification {
        case 1:
            return "Sinus rhythm"
        case 2:
            return "Atrial fibrillation"
        case 3:
            return "Low heart rate"
        case 4:
            return "high heart rate"
        case 5:
            return "Poor Recording"
        default:
            return "Inconclusive"
        }
    }
}
