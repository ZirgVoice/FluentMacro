import FluentMacroMacros
import SwiftSyntax

@attached(extension, names: arbitrary)
public macro FluentSorting() = #externalMacro(module: "FluentMacroMacros", type: "FluentSortingMacro")
@attached(extension, names: arbitrary)
public macro FluentFiltering() = #externalMacro(module: "FluentMacroMacros", type: "FluentFilteringMacro")
// -MARK: Fields
@attached(peer)
public macro FluentSortingField() = #externalMacro(module: "FluentMacroMacros", type: "FluentSortingFieldMacro")
@attached(peer)
public macro FluentFilteringField(methods: [FluentFilteringMethods]) =
    #externalMacro(module: "FluentMacroMacros", type: "FluentFilteringFieldMacro")
