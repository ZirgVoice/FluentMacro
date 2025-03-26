//
//  FluentFilteringMethods.swift
//  FluentMacro
//
//  Created by Rost on 26.03.25.
//

public enum FluentFilteringMethods: String {
    case ilike, equal, notEqual, greaterThan, greaterThanOrEqual, lessThan, lessThanOrEqual, valueInSet, valueNotInSet

    var suffix: String {
        switch self {
        case .ilike: return "ILIKE"
        case .equal: return "EQ"
        case .notEqual: return "NEQ"
        case .greaterThan: return "GT"
        case .greaterThanOrEqual: return "GTE"
        case .lessThan: return "LT"
        case .lessThanOrEqual: return "LTE"
        case .valueInSet: return "VS"
        case .valueNotInSet: return "NVS"
        }
    }

    func queryCondition(property: String) -> String {
        switch self {
        case .ilike:
            return ", .custom(\"\(suffix)\"), \"%\\(\(property)\(suffix))%\""
        case .equal:
            return " == \(property)\(suffix)"
        case .notEqual:
            return " != \(property)\(suffix)"
        case .greaterThan:
            return " > \(property)\(suffix)"
        case .greaterThanOrEqual:
            return " >= \(property)\(suffix)"
        case .lessThan:
            return " < \(property)\(suffix)"
        case .lessThanOrEqual:
            return " <= \(property)\(suffix)"
        case .valueInSet:
            return " ~~ \(property)\(suffix)"
        case .valueNotInSet:
            return " !~ \(property)\(suffix)"
        }
    }

    func typeString(for baseType: String) -> String {
        switch self {
        case .valueInSet, .valueNotInSet:
            return "[\(baseType)]"
        default:
            return baseType
        }
    }
}
