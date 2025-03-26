//import FluentMacro
//import Foundation
//
//@FluentSorting
//@FluentFiltering
//final class TestModel: @unchecked Sendable {
//    static let schema = "test"
//
//    var id: UUID?
//    @FluentSortingField
//    @FluentFilteringField(
//        methods: [
//            .equal,
//            .notEqual,
//            .greaterThan,
//            .greaterThanOrEqual,
//            .lessThan,
//            .lessThanOrEqual,
//        ]
//    )
//    var intField: Int
//    @FluentSortingField
//    @FluentFilteringField(
//        methods: [
//            .equal,
//            .notEqual,
//            .greaterThan,
//            .greaterThanOrEqual,
//            .lessThan,
//            .lessThanOrEqual,
//        ]
//    )
//    var uuidField: UUID
//    @FluentSortingField
//    @FluentFilteringField(
//        methods: [
//            .ilike
//        ]
//    )
//    var stringField: String
//    @FluentSortingField
//    @FluentFilteringField(
//        methods: [
//            .valueInSet,
//            .valueNotInSet
//        ]
//    )
//    var arrayField: [String]
//    @Group(key: .position)
//    var groupField: TestGroup
//    @FluentSortingField
//    @FluentFilteringField(
//        methods: [
//            .equal,
//            .notEqual,
//            .greaterThan,
//            .greaterThanOrEqual,
//            .lessThan,
//            .lessThanOrEqual,
//        ]
//    )
//    var dateField: Date
//    @FluentSortingField
//    @FluentFilteringField(
//        methods: [
//            .equal,
//            .notEqual,
//            .greaterThan,
//            .greaterThanOrEqual,
//            .lessThan,
//            .lessThanOrEqual,
//        ]
//    )
//    var optionalDateField: Date?
//    
//    init() {}
//
//    final class TestGroup {
//        @FluentSortingField
//        @FluentFilteringField(
//            methods: [
//                .equal,
//                .notEqual,
//                .greaterThan,
//                .greaterThanOrEqual,
//                .lessThan,
//                .lessThanOrEqual,
//            ]
//        )
//        var intField: Int
//        @FluentSortingField
//        @FluentFilteringField(
//            methods: [
//                .equal,
//                .notEqual,
//                .greaterThan,
//                .greaterThanOrEqual,
//                .lessThan,
//                .lessThanOrEqual,
//            ]
//        )
//        var uuidField: UUID
//        @FluentSortingField
//        @FluentFilteringField(
//            methods: [
//                .ilike
//            ]
//        )
//        var stringField: String
//        @FluentSortingField
//        @FluentFilteringField(
//            methods: [
//                .valueInSet,
//                .valueNotInSet
//            ]
//        )
//        var arrayField: [String]
//        @FluentSortingField
//        @FluentFilteringField(
//            methods: [
//                .equal,
//                .notEqual,
//                .greaterThan,
//                .greaterThanOrEqual,
//                .lessThan,
//                .lessThanOrEqual,
//            ]
//        )
//        var dateField: Date
//        @FluentSortingField
//        @FluentFilteringField(
//            methods: [
//                .equal,
//                .notEqual,
//                .greaterThan,
//                .greaterThanOrEqual,
//                .lessThan,
//                .lessThanOrEqual,
//            ]
//        )
//        var optionalDateField: Date?
//        
//        init() {}
//    }
//}
