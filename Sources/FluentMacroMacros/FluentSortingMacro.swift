//
//  FluentSortingMacro.swift
//  FluentMacro
//
//  Created by Rost on 14.08.24.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct FluentSortingMacro: ExtensionMacro, MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        var queryBuilderCases: [String] = []

        guard let classDecl = ClassDeclSyntax(declaration) else {
            throw MacroExpansionErrorMessage("Should only be used with class.")
        }
        let modelName = classDecl.name

        for member in classDecl.memberBlock.members {
            let variableDecl = member.decl.as(VariableDeclSyntax.self)
            let property = variableDecl?.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            let attribute = variableDecl?.attributes.first {
                $0.as(AttributeSyntax.self)?.attributeName
                    .as(IdentifierTypeSyntax.self)?.description == "FluentSortingField"
            }

            if let property, attribute != nil {
                queryBuilderCases.append(
                    """
                                    case .\(property):
                                        query = query.sort(\\.$\(property), direction)
                    """)
            }
        }

        let casesDecl: DeclSyntax = """
            extension QueryBuilder where Model == \(modelName) {
                func sort(direction: DatabaseQuery.Sort.Direction, fieldMany: [\(modelName).Sort]) -> Self {
                    var query = self
                    fieldMany.forEach { field in
                        switch field {
            \(raw: queryBuilderCases.joined(separator: "\n"))
                        }
                    }
                    return query
                }
            }
            """

        guard let extensionDecl = casesDecl.as(ExtensionDeclSyntax.self) else {
            return []
        }

        return [extensionDecl]
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        var sortCases: [String] = []

        guard let classDecl = ClassDeclSyntax(declaration) else {
            throw MacroExpansionErrorMessage("Should only be used with class.")
        }

        for member in classDecl.memberBlock.members {
            let variableDecl = member.decl.as(VariableDeclSyntax.self)
            let property = variableDecl?.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            let attribute = variableDecl?.attributes.first {
                $0.as(AttributeSyntax.self)?.attributeName
                    .as(IdentifierTypeSyntax.self)?.description == "FluentSortingField"
            }

            if let property, attribute != nil {
                sortCases.append(
                    """
                        case \(property)
                    """)
            }
        }

        let casesDecl: DeclSyntax = """
            enum Sort: String, Codable, CaseIterable {
            \(raw: sortCases.joined(separator: "\n"))
            }
            """

        return [casesDecl]
    }
}

// MARK: - Field

public struct FluentSortingFieldMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] { .init() }
}
