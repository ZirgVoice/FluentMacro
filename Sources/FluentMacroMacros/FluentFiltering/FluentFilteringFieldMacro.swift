//
//  FluentFilteringFieldMacro.swift
//  FluentMacro
//
//  Created by Rost on 24.03.25.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct FluentFilteringFieldMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let variableDecl = declaration.as(VariableDeclSyntax.self)
        let elements = try extractMethods(from: node)
        let valueTypeIsArray = variableDecl?.bindings.first?.typeAnnotation?.type.is(ArrayTypeSyntax.self) ?? false
        
        try validateMethods(elements, valueTypeIsArray, variableDecl)

        return .init()
    }

    // MARK: - Helpers

    private static func extractMethods(from node: AttributeSyntax) throws -> [FluentFilteringMethods] {
        let argumentName = "methods"
        let argument = node.arguments?.as(LabeledExprListSyntax.self)?.first { $0.label?.text == argumentName }
        let attributes = LabeledExprSyntax(argument)?.expression.as(ArrayExprSyntax.self)?.elements

        let methods: [FluentFilteringMethods] = attributes?.compactMap {
            if let name = $0.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
                return FluentFilteringMethods(rawValue: name)
            }

            return nil
        } ?? []
        
        guard !methods.isEmpty else {
            throw MacroExpansionErrorMessage("The `\(argumentName)` argument cannot be empty!")
        }
        
        return methods
    }

    private static func validateMethods(
        _ methods: [FluentFilteringMethods],
        _ valueTypeIsArray: Bool,
        _ variableDecl: VariableDeclSyntax?
    ) throws {
        try checkValueInSet(methods, valueTypeIsArray)
        try checkIlikeValue(methods, variableDecl)
    }

    private static func checkValueInSet(_ methods: [FluentFilteringMethods], _ valueTypeIsArray: Bool) throws {
        let errorMessage: (String) -> String = { "The `\($0)` method cannot be used with Array types!" }
        let valueInSet = FluentFilteringMethods.valueInSet
        let valueNotInSet = FluentFilteringMethods.valueNotInSet

        if methods.contains(where: { $0 == valueInSet }), valueTypeIsArray {
            throw MacroExpansionErrorMessage(errorMessage(valueInSet.rawValue))
        }
        if methods.contains(where: { $0 == valueNotInSet }), valueTypeIsArray {
            throw MacroExpansionErrorMessage(errorMessage(valueNotInSet.rawValue))
        }
    }

    private static func checkIlikeValue(
        _ methods: [FluentFilteringMethods],
        _ variableDecl: VariableDeclSyntax?
    ) throws {
        let typeName = "String"
        let ilike = FluentFilteringMethods.ilike
        let hasIlikeValue = methods.contains { $0 == ilike }
        let isString =
            variableDecl?.bindings.first?.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text == typeName

        if !isString, hasIlikeValue {
            throw MacroExpansionErrorMessage("The `\(ilike.rawValue)` method can only be used with the `\(typeName)` type!")
        }
    }
}
