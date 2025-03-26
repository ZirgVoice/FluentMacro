//
//  FluentSortingMacro.swift
//  FluentMacro
//
//  Created by Rost on 14.08.24.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct FluentSortingMacro: ExtensionMacro {
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
        var queryBuilderCases: [String] = .init()
        var sortCases: [String] = .init()

        try create(sortCases: &sortCases, queryBuilderCases: &queryBuilderCases, from: classDecl)

        return [
            createSortingExtension(for: modelName.text, sortCases: sortCases),
            createQueryBuilderExtension(for: modelName.text, queryBuilderCases: queryBuilderCases),
        ]
    }

    // MARK: - Helpers

    private static func create(
        sortCases: inout [String],
        queryBuilderCases: inout [String],
        from classDecl: ClassDeclSyntax,
        mainModelFieldName: String? = nil
    ) throws {
        for member in classDecl.memberBlock.members {
            guard let variableDecl = member.decl.as(VariableDeclSyntax.self),
                let property = variableDecl.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                let type = extractType(from: variableDecl),
                let attribute = variableDecl.attributes.first(where: {
                    isFluentSortingFieldOrGroup($0.cast(AttributeSyntax.self))
                })?.cast(AttributeSyntax.self)
            else {
                continue
            }

            if attribute.attributeName.trimmedDescription == "Group" {
                guard
                    let groupClass = classDecl.memberBlock.members
                        .compactMap({ $0.decl.as(ClassDeclSyntax.self) })
                        .first(where: { $0.name.text == type })
                else {
                    throw MacroExpansionErrorMessage(
                        "Class `\(type)` must be inside class `\(classDecl.name.trimmedDescription)`."
                    )
                }

                try create(
                    sortCases: &sortCases,
                    queryBuilderCases: &queryBuilderCases,
                    from: groupClass,
                    mainModelFieldName: property
                )
            } else {
                var field = property

                if let mainModelFieldName {
                    field = "\(mainModelFieldName).$\(property)"
                }
                queryBuilderCases.append(
                    """
                    case .\(property):
                        query = query.sort(\\.$\(field), direction)
                    """
                )
                sortCases.append("case \(property)")
            }
        }
    }

    private static func isFluentSortingFieldOrGroup(_ attribute: AttributeSyntax) -> Bool {
        guard let name = attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.text else { return false }

        return name == "FluentSortingField" || name == "Group"
    }

    private static func createSortingExtension(for modelName: String, sortCases: [String]) -> ExtensionDeclSyntax {
        let sortDecl: DeclSyntax = """
            extension \(raw: modelName) {
                enum Sort: String, Codable, CaseIterable {
            \(raw: sortCases.joined(separator: "\n"))
                }
            }
            """
        return sortDecl.as(ExtensionDeclSyntax.self)!
    }

    private static func createQueryBuilderExtension(
        for modelName: String,
        queryBuilderCases: [String]
    ) -> ExtensionDeclSyntax {
        let queryBuilderDecl: DeclSyntax = """
            extension QueryBuilder where Model == \(raw: modelName) {
                func sort(fields: [\(raw: modelName).Sort: DatabaseQuery.Sort.Direction]) -> Self {
                    var query = self
                    fields.forEach { field in
                        switch field {
            \(raw: queryBuilderCases.joined(separator: "\n"))
                        }
                    }
                    return query
                }
            }
            """

        return queryBuilderDecl.as(ExtensionDeclSyntax.self)!
    }
}
