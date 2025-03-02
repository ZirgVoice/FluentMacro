//
//  FluentMacroPlugin.swift
//  FluentMacro
//
//  Created by Rost on 14.08.24.
//
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct FluentMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FluentSortingMacro.self,
        FluentFilteringMacro.self,
        FluentSortingFieldMacro.self,
        FluentFilteringFieldMacro.self,
    ]
}
