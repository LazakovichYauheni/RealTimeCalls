//
//  UIError.swift
//  WaveForm
//
//  Created by Doctor Kocte on 5.06.23.
//

import Foundation

public enum UIError: Error {
    case server
    case wrongUrl
    case unknown
    case emptyPath
    case noData
    case notParsableData

    var description: String {
        switch self {
        case .server:
            return "Ошибка сервера"

        case .wrongUrl:
            return "Неверный URL"

        case .unknown:
            return "Неизвестная ошибка"

        case .emptyPath:
            return "Пустой путь к файлу"
            
        case .noData:
            return "Нет данных"
            
        case .notParsableData:
            return "Не удалось распарсить данные"
        }
    }
}
