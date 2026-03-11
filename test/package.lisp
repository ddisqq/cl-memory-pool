;;;; test/package.lisp - Test package for cl-memory-pool

(defpackage #:cl-memory-pool.test
  (:use #:cl #:cl-memory-pool)
  (:export #:run-tests))
