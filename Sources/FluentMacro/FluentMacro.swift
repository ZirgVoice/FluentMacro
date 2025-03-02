@attached(extension, names: arbitrary)
@attached(member, names: arbitrary)
public macro FluentSorting() = #externalMacro(module: "FluentMacroMacros", type: "FluentSortingMacro")
@attached(extension, names: arbitrary)
public macro FluentFiltering() = #externalMacro(module: "FluentMacroMacros", type: "FluentFilteringMacro")

@attached(peer)
public macro FluentSortingField() = #externalMacro(module: "FluentMacroMacros", type: "FluentSortingFieldMacro")
@attached(peer)
public macro FluentFilteringField(methods: [FluentFilteringMethods]) =
    #externalMacro(module: "FluentMacroMacros", type: "FluentFilteringFieldMacro")

public enum FluentFilteringMethods: String {
    case ilike
    case equal
    case notEqual
    case greaterThan
    case greaterThanOrEqual
    case lessThan
    case lessThanOrEqual
    case valueInSet
    case valueNotInSet
}
