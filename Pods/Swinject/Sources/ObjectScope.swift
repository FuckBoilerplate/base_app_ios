//
//  ObjectScope.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 7/24/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

/// A configuration how an instance provided by a `Container` is shared in the system.
/// The configuration is ignored if it is applied to a value type.
///
/// **Cases:**
///
/// - none
/// - graph
/// - container
/// - hierarchy
public enum ObjectScope: String {
    /// A new instance is always created by the `Container` when a type is resolved.
    /// The instance is not shared. (aka Transient scope.)
    case none

    /// Instances are shared only when an object graph is being created,
    /// otherwise a new instance is created by the `Container`. This is the default scope.
    case graph

    /// An instance provided by the `Container` is shared within the `Container`. (aka Singleton scope in the `Container`.)
    case container

    /// An instance provided by the `Container` is not only shared within the `Container` but also shared within its child `Containers`.
    case hierarchy
}

extension ObjectScope: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}
