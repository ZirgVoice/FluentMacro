import SwiftSyntax
import SwiftSyntaxMacros

extension ExtensionMacro {
    static func extractType(from variableDecl: VariableDeclSyntax) -> String? {
        let type = variableDecl.bindings.first?.typeAnnotation?.type

        if let arrayType = type?.as(ArrayTypeSyntax.self) {
            return arrayType.element.as(IdentifierTypeSyntax.self)?.name.text
        } else if let optionalType = type?.as(OptionalTypeSyntax.self) {
            return optionalType.wrappedType.as(IdentifierTypeSyntax.self)?.name.text
        } else {
            return type?.as(IdentifierTypeSyntax.self)?.name.text
        }
    }
}
