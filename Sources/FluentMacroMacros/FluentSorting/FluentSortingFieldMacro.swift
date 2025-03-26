//
//  FluentSortingFieldMacro.swift
//  FluentMacro
//
//  Created by Rost on 22.03.25.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct FluentSortingFieldMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] { .init() }
}
