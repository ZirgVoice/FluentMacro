//
//  FluentFilteringMacro.swift
//  FluentMacro
//
//  Created by Rost on 14.08.24.
//
import SwiftSyntax
import SwiftSyntaxMacros

public struct FluentFilteringMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let classDecl = ClassDeclSyntax(declaration) else {
            throw MacroExpansionErrorMessage("Should only be used with class.")
        }
        
        let modelName = classDecl.name
        var queryBuilderCases = [String]()
        var filterCases = [String]()
        
        for member in classDecl.memberBlock.members {
            guard let variableDecl = member.decl.as(VariableDeclSyntax.self),
                  let property = variableDecl.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                  let type = extractType(from: variableDecl),
                  let attribute = variableDecl.attributes.first(where: { isFluentFilteringField($0.cast(AttributeSyntax.self)) })?.cast(AttributeSyntax.self) else {
                continue
            }
            
            if let elements = extractFilterMethods(from: attribute) {
                processFilterMethods(elements, property: property, type: type, queryBuilderCases: &queryBuilderCases, filterCases: &filterCases)
            }
        }
        
        return [
            createFilterExtension(for: modelName.text, filterCases: filterCases),
            createQueryBuilderExtension(for: modelName.text, queryBuilderCases: queryBuilderCases)
        ]
    }
}

// MARK: - Helpers

private func extractType(from variableDecl: VariableDeclSyntax) -> String? {
    if let arrayType = variableDecl.bindings.first?.typeAnnotation?.type.as(ArrayTypeSyntax.self) {
        return arrayType.element.as(IdentifierTypeSyntax.self)?.name.text
    }
    return variableDecl.bindings.first?.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text
}

private func isFluentFilteringField(_ attribute: AttributeSyntax) -> Bool {
    return attribute.attributeName.as(IdentifierTypeSyntax.self)?.description == "FluentFilteringField"
}

private func extractFilterMethods(from attribute: AttributeSyntax) -> [FluentFilteringMethods]? {
    guard let argument = attribute.arguments?.as(LabeledExprListSyntax.self)?.first(where: { $0.label?.text == "methods" }),
          let elements = argument.expression.as(ArrayExprSyntax.self)?.elements else {
        return nil
    }
    
    return elements.compactMap { $0.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text }
        .compactMap(FluentFilteringMethods.init(rawValue:))
}

private func processFilterMethods(_ methods: [FluentFilteringMethods], property: String, type: String, queryBuilderCases: inout [String], filterCases: inout [String]) {
    methods.forEach {
        let suffix: String
        let queryCondition: String
        
        switch $0 {
        case .ilike:
            suffix = "ILIKE"
            queryCondition = ".custom(\"ILIKE\"), \"%\\(\(property)\(suffix)%\""
        case .equal:
            suffix = "EQ"
            queryCondition = "== \(property)\(suffix)"
        case .notEqual:
            suffix = "NEQ"
            queryCondition = "!= \(property)\(suffix)"
        case .greaterThan:
            suffix = "GT"
            queryCondition = "> \(property)\(suffix)"
        case .greaterThanOrEqual:
            suffix = "GTE"
            queryCondition = ">= \(property)\(suffix)"
        case .lessThan:
            suffix = "LT"
            queryCondition = "< \(property)\(suffix)"
        case .lessThanOrEqual:
            suffix = "LTE"
            queryCondition = "<= \(property)\(suffix)"
        case .valueInSet:
            suffix = "VS"
            queryCondition = "~~ \(property)\(suffix)"
        case .valueNotInSet:
            suffix = "NVS"
            queryCondition = "!~ \(property)\(suffix)"
        }
        
        queryBuilderCases.append("if let \(property)\(suffix) = args.\(property)\(suffix) { query.filter(\\.$\(property), \(queryCondition)) }")
        filterCases.append("var \(property)\(suffix): \(type)\(suffix.hasSuffix("VS") ? "[]" : "")?")
    }
}

private func createFilterExtension(for modelName: String, filterCases: [String]) -> ExtensionDeclSyntax {
    let filterDecl: DeclSyntax = """
        extension \(raw: modelName) {
            struct Filter: Codable, Hashable {
                \(raw: filterCases.joined(separator: "\n"))
            }
        }
        """
    return filterDecl.as(ExtensionDeclSyntax.self)!
}

private func createQueryBuilderExtension(for modelName: String, queryBuilderCases: [String]) -> ExtensionDeclSyntax {
    let queryBuilderDecl: DeclSyntax = """
        extension QueryBuilder where Model == \(raw: modelName) {
            func filter(with args: \(raw: modelName).Filter) -> Self {
                var query = self
                \(raw: queryBuilderCases.joined(separator: "\n"))
                return query
            }
        }
        """
    return queryBuilderDecl.as(ExtensionDeclSyntax.self)!
}

// MARK: - FluentFilteringMethods Enum

private enum FluentFilteringMethods: String {
    case ilike, equal, notEqual, greaterThan, greaterThanOrEqual, lessThan, lessThanOrEqual, valueInSet, valueNotInSet
}
