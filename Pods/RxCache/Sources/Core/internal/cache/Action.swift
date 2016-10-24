// Action.swift
// RxCache
//
// Copyright (c) 2016 Victor Albertos https://github.com/VictorAlbertos
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

private let PrefixDynamicKey = "$d$d$d$"
private let PrefixDynamicKeyGroup = "$g$g$g$"

protocol Action {
    var memory : Memory {get}
}

extension Action {

    func composeKey(_ providerKey: String, dynamicKey : DynamicKey?, dynamicKeyGroup : DynamicKeyGroup?) -> String {
        var dynamicKeyValue = ""
        var dynamicKeyGroupValue = ""
        
        if dynamicKey != nil {
            dynamicKeyValue = dynamicKey!.dynamicKey
        }
        
        if dynamicKeyGroup != nil {
            dynamicKeyValue = dynamicKeyGroup!.dynamicKey
            dynamicKeyGroupValue = dynamicKeyGroup!.group
        }
        
        return providerKey + PrefixDynamicKey + dynamicKeyValue + PrefixDynamicKeyGroup + dynamicKeyGroupValue
    }
    
    func getKeysMatchingProviderKey(_ providerKey: String) -> [String] {
        var keysMatchingProviderKey = [String]()
        
        memory.keys().forEach { (composedKeyMemory) -> () in
            let keyPartProviderMemory  = getPartOfTarget(target: PrefixDynamicKey, composedKeyMemory: composedKeyMemory)
            
            if providerKey == keyPartProviderMemory {
                keysMatchingProviderKey.append(composedKeyMemory)
            }
        }

        return keysMatchingProviderKey
    }
    
    func getKeysMatchingDynamicKey(_ providerKey: String, dynamicKey : DynamicKey?) -> [String] {
        var dynamicKeyValue = ""
        
        if dynamicKey != nil {
            dynamicKeyValue = dynamicKey!.dynamicKey
        }
        
        var keysMatchingDynamicKey = [String]()
        
        let composedProviderKeyAndDynamicKey = providerKey + PrefixDynamicKey + dynamicKeyValue

        memory.keys().forEach { (composedKeyMemory) -> () in
            let keyPartProviderAndDynamicKeyMemory  = getPartOfTarget(target: PrefixDynamicKeyGroup, composedKeyMemory: composedKeyMemory)
            
            if composedProviderKeyAndDynamicKey == keyPartProviderAndDynamicKeyMemory {
                keysMatchingDynamicKey.append(composedKeyMemory)
            }
        }
        
        return keysMatchingDynamicKey
    }
    
    func getKeyMatchingDynamicKeyGroup(_ providerKey: String, dynamicKey : DynamicKey?, dynamicKeyGroup : DynamicKeyGroup?) -> String {
        return composeKey(providerKey, dynamicKey: dynamicKey, dynamicKeyGroup: dynamicKeyGroup)
    }
    
    private func getPartOfTarget(target: String, composedKeyMemory: String) -> String? {
        if let range = composedKeyMemory.range(of: target, options: .backwards) {
            
            let indexPrefixDynamicKey = composedKeyMemory.distance(from: composedKeyMemory.startIndex, to: range.lowerBound)
            let endPositionKey = composedKeyMemory.characters.count - indexPrefixDynamicKey
            let finalIndex = composedKeyMemory.index(composedKeyMemory.endIndex, offsetBy: -endPositionKey)
            
            return composedKeyMemory.substring(with: Range<String.Index>(composedKeyMemory.startIndex..<finalIndex))
        } else {
            return nil
        }
    }

}
