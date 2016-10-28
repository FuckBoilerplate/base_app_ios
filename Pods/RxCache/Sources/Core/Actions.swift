//
//  Actions.swift
//  RxCache
//
//  Created by Roberto Frontado on 4/15/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

open class Actions<T> {
    
    public typealias Evict = (_ elements: [T]) -> Observable<[T]>
    public typealias Func1Count = (_ count: Int) -> Bool
    public typealias Func1Element = (_ element: T) -> Bool
    public typealias Func2 = (_ position: Int, _ count: Int) -> Bool
    public typealias Func3 = (_ position: Int, _ count: Int, _ element: T) -> Bool
    public typealias Replace = (_ element: T) -> T
    
    fileprivate var cache: Observable<[T]>
    fileprivate let evict: Evict
    
    fileprivate init(cache: Observable<[T]>, evict: @escaping Evict) {
        self.cache = cache
        self.evict = evict
    }
    
    open static func with<T>(_ provider: Provider) -> Actions<T> {
        let cacheProvider = PlaceholderCacheProvider(provider: provider)
        let oCache = RxCache.Providers.cache(RxCache.errorObservable([T].self), provider: cacheProvider)
        
        let evictProvider = PlaceholderEvictProvider(provider: provider)
        let evictBlock = { (elements: [T]) -> Observable<[T]> in
            return RxCache.Providers.cache(Observable.just(elements), provider: evictProvider)
        }
        
        return Actions<T>(cache: oCache, evict: evictBlock)
    }
    
    // MARK: - Actions
    
    // MARK: - Add
    /**
    *
    * @param exchange2
    * @param candidate the element to add
    * @return the instance itself to keep chain
    */
    open func add(_ func2: @escaping Func2, candidate: T) -> Actions<T> {
        return addAll(func2, candidates: [candidate])
    }
    
    /**
     * Add the object at the first position of the cache.
     * @param element the object to add to the cache.
     * @return itself
     */
    open func addFirst(_ candidate: T) -> Actions<T> {
        return addAll({ (position, count)in position == 0 }, candidates: [candidate])
    }
    
    /**
     * Add the object at the last position of the cache.
     * @param element the object to add to the cache.
     * @return itself
     */
    open func addLast(_ candidate: T) -> Actions<T> {
        return addAll({ (position, count)in position == count }, candidates: [candidate])
    }
    
    /**
     * Add the objects at the first position of the cache.
     * @param elements the objects to add to the cache.
     * @return itself
     */
    open func addAllFirst(_ elements: [T]) -> Actions<T> {
        return addAll({ (position, count) in position == 0 }, candidates: elements)
    }
    
    /**
     * Add the objects at the last position of the cache.
     * @param elements the objects to add to the cache.
     * @return itself
     */
    open func addAllLast(_ elements: [T]) -> Actions<T> {
        return addAll({ (position, count) in position == count }, candidates: elements)
    }
    
    /**
     * Func2 will be called for every iteration until its condition returns true.
     * When true, the elements are added to the cache at the position of the current iteration.
     * @param func2 exposes the position of the current iteration and the count of elements in the cache.
     * @param elements the objects to add to the cache.
     * @return itself
     */
    open func addAll(_ func2: @escaping Func2, candidates: [T]) -> Actions<T> {
        cache = cache.map { (elements) -> [T] in
            // Due Swift 3 deprecated 'var' in the closure
            var elements = elements
            let count = elements.count
            for position in 0..<(count + 1) {
                if func2(position, count) {
                    elements.insert(contentsOf: candidates, at: position)
                    break
                }
            }
            return elements
        }
        return self
    }
    
    // MARK: - Evict
    /**
    * Evict object at the first position of the cache
    * @return itself
    */
    open func evictFirst() -> Actions<T> {
        return evict { (position, count, element) in position == 0 }
    }
    
    /**
    * Evict as much objects as requested by n param starting from the first position.
    * @param n the amount of elements to evict.
    * @return itself
    */
    open func evictFirstN(_ n: Int) -> Actions<T> {
        return evictFirstN({ count in true }, n: n)
    }
    
    /**
    * Evict object at the last position of the cache.
    * @return itself
    */
    open func evictLast() -> Actions<T> {
        return evict { (position, count, element) in position == count - 1 }
    }
    
    /**
    * Evict as much objects as requested by n param starting from the last position.
    * @param n the amount of elements to evict.
    * @return itself
    */
    open func evictLastN(_ n: Int) -> Actions<T> {
        return evictLastN({ count in true }, n: n)
    }
    
    /**
     * Evict object at the first position of the cache.
     * @param func1Count exposes the count of elements in the cache.
     * @return itself
     */
    open func evictFirst(_ func1Count: @escaping Func1Count) -> Actions<T> {
        return evict { (position, count, element) in position == 0 && func1Count(count) }
    }
    
    /**
     * Evict as much objects as requested by n param starting from the first position.
     * @param func1Count exposes the count of elements in the cache.
     * @param n the amount of elements to evict.
     * @return itself
     */
    open func evictFirstN(_ func1Count: @escaping Func1Count, n: Int) -> Actions<T> {
        return evictIterable { (position, count, element) in
            position < n && func1Count(count)
        }
    }
    
    /**
     * Evict object at the last position of the cache.
     * @param func1Count exposes the count of elements in the cache.
     * @return itself
     */
    open func evictLast(_ func1Count: @escaping Func1Count) -> Actions<T> {
        return evict { (position, count, element) in position == count - 1 && func1Count(count) }
    }
    
    /**
    * Evict as much objects as requested by n param starting from the last position.
    * @param func1Count exposes the count of elements in the cache.
    * @param n the amount of elements to evict.
    * @return itself
    */
    open func evictLastN(_ func1Count: @escaping Func1Count, n: Int) -> Actions<T> {
        return evictIterable({ (position, count, element) in count - position <= n && func1Count(count)
        })
    }
     
    /**
     * Func1Element will be called for every iteration until its condition returns true.
     * When true, the element of the current iteration is evicted from the cache.
     * @param func1Element exposes the element of the current iteration.
     * @return itself
     */
    open func evict(_ func1Element: @escaping Func1Element) -> Actions<T> {
        return evict { (position, count, element) in func1Element(element) }
    }
    
    /**
     * Func3 will be called for every iteration until its condition returns true.
     * When true, the element of the current iteration is evicted from the cache.
     * @param func3 exposes the position of the current iteration, the count of elements in the cache and the element of the current iteration.
     * @return itself
     */
    open func evict(_ func3: @escaping Func3) -> Actions<T> {
        cache = cache.map { (elements) in
            // Due Swift 3 deprecated 'var' in the closure
            var elements = elements
            let count = elements.count
            for position in 0..<count {
                if func3(position, count, elements[position]) {
                    elements.remove(at: position)
                    break
                }
            }
            return elements
        }
        return self
    }
    
    /**
     * Evict all elements from the cache
     * @return itself
     */
    open func evictAll() -> Actions<T> {
        return evictIterable { (position, count, element) in true }
    }
    
    /**
    * Evict elements from the cache starting from the first position until its count is equal to the value specified in n param.
    * @param n the amount of elements to keep from evict.
    * @return itself
    */
    open func evictAllKeepingFirstN(_ n: Int) -> Actions<T> {
        return evictIterable { (position, count, element) in
            let positionToStartEvicting = count - (count - n)
            return position >= positionToStartEvicting
        }
    }
    
    /**
    * Evict elements from the cache starting from the last position until its count is equal to the value specified in n param.
    * @param n the amount of elements to keep from evict.
    * @return itself
    */
    open func evictAllKeepingLastN(_ n: Int) -> Actions<T> {
        return evictIterable { (position, count, element) in
            let elementsToEvict = count - n
            return position < elementsToEvict
        }
    }
    
    /**
     * Func3 will be called for every iteration.
     * When true, the element of the current iteration is evicted from the cache.
     * @param func3 exposes the position of the current iteration, the count of elements in the cache and the element of the current iteration.
     * @return itself
     */
    open func evictIterable(_ func3: @escaping Func3) -> Actions<T> {
        cache = cache.map { (elements) in
            // Due Swift 3 deprecated 'var' in the closure
            var elements = elements
            let count = elements.count
            // Inverse for
            for position in (0...count - 1).reversed() {
                if func3(position, count, elements[position]) {
                    elements.remove(at: position)
                }
            }
            return elements
        }
        return self
    }
    
    // MARK: - Update
    /**
    * Func1Element will be called for every iteration until its condition returns true.
    * When true, the element of the current iteration is updated.
    * @param func1Element exposes the element of the current iteration.
    * @param replace exposes the original element and expects back the one modified.
    * @return itself
    */
    open func update(_ func1Element: @escaping Func1Element, replace: @escaping Replace) -> Actions<T> {
        return update({ (position, count, element) in func1Element(element) }
            , replace: { element in replace(element) })
    }
    
    /**
     * Func3 will be called for every iteration until its condition returns true.
     * When true, the element of the current iteration is updated.
     * @param func3 exposes the position of the current iteration, the count of elements in the cache and the element of the current iteration.
     * @param replace exposes the original element and expects back the one modified.
     * @return itself
     */
    open func update(_ func3: @escaping Func3, replace: @escaping Replace) -> Actions<T> {
        cache = cache.map { (elements) in
            // Due Swift 3 deprecated 'var' in the closure
            var elements = elements
            let count = elements.count
            for position in 0..<count {
                if func3(position, count, elements[position]) {
                    elements[position] = replace(elements[position])
                    break
                }
            }
            return elements
        }
        return self
    }
    
    /**
     * Func1Element will be called for every.
     * When true, the element of the current iteration is updated.
     * @param func1Element exposes the element of the current iteration.
     * @param replace exposes the original element and expects back the one modified.
     * @return itself
     */
    open func updateIterable(_ func1Element: @escaping Func1Element, replace: @escaping Replace) -> Actions<T> {
        return updateIterable({ (position, count, element) in func1Element(element)
            }, replace: { element in replace(element) })
    }
    
    /**
     * Func3 will be called for every iteration.
     * When true, the element of the current iteration is updated.
     * @param func3 exposes the position of the current iteration, the count of elements in the cache and the element of the current iteration.
     * @param replace exposes the original element and expects back the one modified.
     * @return itself
     */
    open func updateIterable(_ func3: @escaping Func3, replace: @escaping Replace) -> Actions<T> {
        cache = cache.map { (elements) in
            // Due Swift 3 deprecated 'var' in the closure
            var elements = elements
            let count = elements.count
            for position in 0..<count {
                if func3(position, count, elements[position]) {
                    elements[position] = replace(elements[position])
                }
            }
            return elements
        }
        return self
    }
    
    // MARK: - To Observable
    open func toObservable() -> Observable<[T]> {
        return cache.flatMap { elements in self.evict(elements) }
    }
}
