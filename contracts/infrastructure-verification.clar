;; Infrastructure Verification Contract
;; Validates critical city systems and their operational status

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_SYSTEM_NOT_FOUND (err u101))
(define-constant ERR_INVALID_STATUS (err u102))

;; Infrastructure system data structure
(define-map infrastructure-systems
  { system-id: uint }
  {
    name: (string-ascii 50),
    category: (string-ascii 20),
    status: (string-ascii 20),
    last-verified: uint,
    verifier: principal,
    critical-level: uint
  }
)

;; System verification history
(define-map verification-history
  { system-id: uint, verification-id: uint }
  {
    timestamp: uint,
    verifier: principal,
    status: (string-ascii 20),
    notes: (string-ascii 200)
  }
)

;; Counters
(define-data-var next-system-id uint u1)
(define-data-var next-verification-id uint u1)

;; Register new infrastructure system
(define-public (register-system (name (string-ascii 50)) (category (string-ascii 20)) (critical-level uint))
  (let ((system-id (var-get next-system-id)))
    (map-set infrastructure-systems
      { system-id: system-id }
      {
        name: name,
        category: category,
        status: "pending",
        last-verified: block-height,
        verifier: tx-sender,
        critical-level: critical-level
      }
    )
    (var-set next-system-id (+ system-id u1))
    (ok system-id)
  )
)

;; Verify system status
(define-public (verify-system (system-id uint) (status (string-ascii 20)) (notes (string-ascii 200)))
  (let ((verification-id (var-get next-verification-id)))
    (match (map-get? infrastructure-systems { system-id: system-id })
      system-data
      (begin
        ;; Update system status
        (map-set infrastructure-systems
          { system-id: system-id }
          (merge system-data {
            status: status,
            last-verified: block-height,
            verifier: tx-sender
          })
        )
        ;; Record verification history
        (map-set verification-history
          { system-id: system-id, verification-id: verification-id }
          {
            timestamp: block-height,
            verifier: tx-sender,
            status: status,
            notes: notes
          }
        )
        (var-set next-verification-id (+ verification-id u1))
        (ok verification-id)
      )
      ERR_SYSTEM_NOT_FOUND
    )
  )
)

;; Get system information
(define-read-only (get-system (system-id uint))
  (map-get? infrastructure-systems { system-id: system-id })
)

;; Get verification history
(define-read-only (get-verification (system-id uint) (verification-id uint))
  (map-get? verification-history { system-id: system-id, verification-id: verification-id })
)

;; Get systems by status
(define-read-only (get-system-count)
  (var-get next-system-id)
)
