//
//  Logger.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 24.08.2021.
//

import Foundation

enum LoggerLevels: Int {
    case None = 0
    case Error
    case Warning
    case Success
    case Info
    case Custom
}

class Logger {

    static let instance = Logger()

    private enum PathLengths: Int {
        case None = 0
        case Short
        case Long
    }

    private let dateFormatter = DateFormatter()
    var verbosityLevel: LoggerLevels = .Custom
    private let pathLength: PathLengths = .Short
    private let timeStampState: Bool = false

    func logMessage(message: String, _ logLevel: LoggerLevels = .Info, file: String = #file, method: String = #function, line: UInt = #line) {

        var outputMessage: String = ""

        if self.verbosityLevel.rawValue > LoggerLevels.None.rawValue && logLevel.rawValue <= self.verbosityLevel.rawValue {
            switch self.pathLength.rawValue {
            case PathLengths.Long.rawValue:
                outputMessage += "\(getGlyphForLogLevel(logLevel: logLevel))\(message) [\(file):\(line)] \(message)"
                break
            case PathLengths.Short.rawValue:
                outputMessage += "\(getGlyphForLogLevel(logLevel: logLevel))\(message) [\(NSURL(fileURLWithPath: file).deletingPathExtension!.lastPathComponent):\(method):\(line)]"
                break
            default:
                outputMessage += "\(getGlyphForLogLevel(logLevel: logLevel))\(message)"
                break
            }

            self.timeStampState ? print(outputMessage + " " + self.getTimeStamp()) : print(outputMessage)
        }
    }

    private func getGlyphForLogLevel(logLevel: LoggerLevels) -> String {
        switch logLevel {
        case .Error:
            return "❌ "
        case .Warning:
            return "⚠️ "
        case .Success:
            return "✅ "
        case .Info:
            return "ℹ️ "
        case .Custom:
            return "❕ "
        default:
            return " "
        }
    }

    private func getTimeStamp() -> String {
        dateFormatter.dateFormat = "HH:mm:ss.zzz"
        let timeStamp = dateFormatter.string(from: Date())
        return "[" + timeStamp + "]"
    }
}
