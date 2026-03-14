;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

(defstruct memory_pool-obj state value)
(defun create (&rest args)
  "Create instance."
  (make-memory_pool-obj :state :initialized :value args))
(defun process (obj)
  "Process the object."
  (list :processed t :result (memory_pool-obj-value obj)))
(defun get-state (obj)
  "Get object state."
  (memory_pool-obj-state obj))

