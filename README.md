# cl-memory-pool

Thread-safe object pooling and multi-policy caching for SBCL using native threading primitives.

## Features

- **Object pooling** - Reuse frequently allocated objects to reduce GC pressure
- **Thread-safe** - All operations protected by SBCL native mutexes
- **Multi-policy cache** - LRU, FIFO, and random eviction policies
- **Statistics tracking** - Hit rates, utilization, and health monitoring
- **Zero dependencies** - Pure SBCL, no external libraries

## Requirements

- SBCL (tested on 2.x)
- ASDF

## Installation

```lisp
(asdf:load-system :cl-memory-pool)
```

## Quick Start

### Object Pooling

```lisp
(use-package :cl-memory-pool)

;; Create a pool for 256-byte buffers
(defparameter *buffer-pool* (create-memory-pool :bytes 256 :max-size 100))

;; Acquire a buffer from the pool
(let ((buffer (pool-acquire *buffer-pool*)))
  (process-data buffer)
  ;; Return to pool for reuse
  (pool-release *buffer-pool* buffer))

;; Check pool statistics
(pool-stats *buffer-pool*)
;; => (:name "pool-bytes-256" :hit-rate 0.95 ...)
```

### Caching

```lisp
;; Create an LRU cache
(defparameter *cache* (create-cache "my-cache" :size 1000 :policy :lru))

;; Store and retrieve values
(cache-put *cache* "user:123" user-data)
(cache-get *cache* "user:123")

;; Check cache performance
(cache-stats *cache*)
;; => (:name "my-cache" :hit-rate 0.87 :entries 543 ...)
```

## API Reference

### Memory Allocation

- `(allocate-memory type size)` - Allocate typed array (:bytes, :uint32, etc.)
- `(free-memory obj)` - Record deallocation
- `(allocate-temporary type size &body body)` - Scoped allocation with cleanup
- `(get-memory-stats)` - Get allocation statistics
- `(reset-memory-stats)` - Clear statistics

### Memory Pool

- `(create-memory-pool type element-size &key max-size name)` - Create pool
- `(pool-acquire pool)` - Get object from pool
- `(pool-release pool element)` - Return object to pool
- `(pool-stats pool)` - Get pool statistics
- `(pool-clear pool)` - Clear pool
- `(check-pool-health pool &key threshold)` - Check health (:healthy, :degraded, :critical)

### Cache

- `(create-cache name &key size policy)` - Create cache (:lru, :fifo, :random)
- `(make-lru-cache name size)` - Create LRU cache
- `(make-fifo-cache name size)` - Create FIFO cache
- `(cache-get cache key)` - Get value
- `(cache-put cache key value)` - Store value
- `(cache-remove cache key)` - Remove entry
- `(cache-clear cache)` - Clear all entries
- `(cache-stats cache)` - Get statistics
- `(check-cache-health cache &key threshold)` - Check health

### Registry

- `(register-pool pool)` - Register pool globally
- `(get-pool name)` - Get registered pool
- `(list-pools)` - List all registered pools
- `(register-cache cache)` - Register cache globally
- `(get-cache name)` - Get registered cache
- `(list-caches)` - List all registered caches
- `(get-all-pool-stats)` - Stats for all pools
- `(get-all-cache-stats)` - Stats for all caches
- `(clear-all-caches)` - Clear all registered caches

## Performance

### Pool Benefits

- **10-100x faster** allocation for frequently created objects
- Reduces GC pauses by reusing objects
- Thread-safe with minimal lock contention

### Cache Hit Rates

| Policy | Best For |
|--------|----------|
| :lru   | Skewed access patterns (recommended) |
| :fifo  | Time-windowed data |
| :random | Preventing timing attacks |

## Testing

```lisp
(asdf:test-system :cl-memory-pool)
```

## License

BSD-3-Clause
