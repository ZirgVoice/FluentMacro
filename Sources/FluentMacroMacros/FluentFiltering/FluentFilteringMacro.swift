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
        var queryBuilderCases: [String] = .init()
        var filterCases: [String] = .init()

        try create(filterCases: &filterCases, queryBuilderCases: &queryBuilderCases, from: classDecl)

        return [
            createFilterExtension(for: modelName.text, filterCases: filterCases),
            createQueryBuilderExtension(for: modelName.text, queryBuilderCases: queryBuilderCases),
        ]
    }

    // MARK: - Helpers
    private static func create(
        filterCases: inout [String],
        queryBuilderCases: inout [String],
        from classDecl: ClassDeclSyntax,
        mainModelFieldName: String? = nil
    ) throws {
        for member in classDecl.memberBlock.members {
            guard let variableDecl = member.decl.as(VariableDeclSyntax.self),
                let property = variableDecl.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                let type = extractType(from: variableDecl),
                let attribute = variableDecl.attributes.first(where: {
                    isFluentFilteringFieldOrGroup($0.cast(AttributeSyntax.self))
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
                    filterCases: &filterCases,
                    queryBuilderCases: &queryBuilderCases,
                    from: groupClass,
                    mainModelFieldName: property
                )
            } else if let elements = extractFilterMethods(from: attribute) {
                var field = property

                if let mainModelFieldName {
                    field = "\(mainModelFieldName).$\(property)"
                }

                processFilterMethods(
                    elements,
                    field: field,
                    property: property,
                    type: type,
                    queryBuilderCases: &queryBuilderCases,
                    filterCases: &filterCases
                )
            }
        }
    }

    private static func isFluentFilteringFieldOrGroup(_ attribute: AttributeSyntax) -> Bool {
        guard let name = attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.text else { return false }

        return name == "FluentFilteringField" || name == "Group"
    }

    private static func extractFilterMethods(from attribute: AttributeSyntax) -> [FluentFilteringMethods]? {
        guard
            let argument = attribute.arguments?.as(LabeledExprListSyntax.self)?.first(where: {
                $0.label?.text == "methods"
            }),
            let elements = argument.expression.as(ArrayExprSyntax.self)?.elements
        else {
            return nil
        }

        return elements.compactMap { $0.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text }
            .compactMap(FluentFilteringMethods.init(rawValue:))
    }

    private static func processFilterMethods(
        _ methods: [FluentFilteringMethods],
        field: String,
        property: String,
        type: String,
        queryBuilderCases: inout [String],
        filterCases: inout [String]
    ) {
        methods.forEach { method in
            let suffix = method.suffix
            let condition = method.queryCondition(property: property)
            let typeStr = method.typeString(for: type)

            queryBuilderCases.append(
                """
                        if let \(property)\(suffix) = args.\(property)\(suffix) {
                            query.filter(\\.$\(field)\(condition))
                        }
                """
            )
            filterCases.append("var \(property)\(suffix): \(typeStr)?")
        }
    }

    private static func createFilterExtension(for modelName: String, filterCases: [String]) -> ExtensionDeclSyntax {
        let filterDecl: DeclSyntax = """
            extension \(raw: modelName) {
                struct Filter: Codable, Hashable {
                    \(raw: filterCases.joined(separator: "\n"))
                }
            }
            """
        return filterDecl.as(ExtensionDeclSyntax.self)!
    }

    private static func createQueryBuilderExtension(
        for modelName: String,
        queryBuilderCases: [String]
    ) -> ExtensionDeclSyntax {
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
}
