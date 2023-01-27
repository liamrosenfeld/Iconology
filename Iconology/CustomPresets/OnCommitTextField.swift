//
//  OnCommitTextField.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 1/14/23.
//  Copyright © 2023 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

typealias UpdateHandler<T> = (_ old: T, _ new: T) -> ()

/// Waits for commit to save the value to the binding
/// onCommit fires after value was written (like the normal TextField but additionally includes the old value)
struct OnCommitTextField<V>: View where V: Equatable {
    private var name: String
    @Binding private var value: V
    private var onCommit: UpdateHandler<V>
    private var formatter: Formatter

    @State private var internalValue: V
    
    var body: some View {
        TextField(
            name,
            value: $internalValue,
            formatter: formatter,
            onCommit: textCommit
        )
        .onChange(of: value) { newValue in
            internalValue = newValue
        }
    }

    func textCommit() {
        if value != internalValue {
            let old = value
            value = internalValue
            onCommit(old, internalValue)
        }
    }
}

extension OnCommitTextField where V == CGFloat {
    init(_ name: String, num: Binding<CGFloat>, onCommit: @escaping UpdateHandler<CGFloat>) {
        self.name = name
        self._value = num
        self._internalValue = State(initialValue: num.wrappedValue)
        self.onCommit = onCommit
        self.formatter = .intFormatter
    }
}

extension OnCommitTextField where V == String {
    init(_ name: String, text: Binding<String>, onCommit: @escaping UpdateHandler<String>) {
        self.name = name
        self._value = text
        self._internalValue = State(initialValue: text.wrappedValue)
        self.onCommit = onCommit
        self.formatter = InOutFormatter()
    }
}

/// formatter that just returns itself
class InOutFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        obj as? String
    }
    
    override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        obj?.pointee = string as AnyObject
        return true
    }
}
