;; Preparedness Planning Contract
;; Manages disaster readiness and emergency plans

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_PLAN_NOT_FOUND (err u301))
(define-constant ERR_INVALID_PRIORITY (err u302))

;; Emergency preparedness plans
(define-map preparedness-plans
  { plan-id: uint }
  {
    title: (string-ascii 100),
    disaster-type: (string-ascii 30),
    description: (string-ascii 500),
    priority: uint,
    status: (string-ascii 20),
    created-by: principal,
    created-at: uint,
    last-updated: uint,
    next-review: uint
  }
)

;; Plan resources and requirements
(define-map plan-resources
  { plan-id: uint, resource-id: uint }
  {
    resource-type: (string-ascii 50),
    quantity-required: uint,
    quantity-available: uint,
    location: (string-ascii 100),
    contact-info: (string-ascii 100)
  }
)

;; Training and drills
(define-map training-records
  { plan-id: uint, training-id: uint }
  {
    training-type: (string-ascii 50),
    participants: uint,
    date-conducted: uint,
    effectiveness-score: uint,
    notes: (string-ascii 300)
  }
)

;; Counters
(define-data-var next-plan-id uint u1)
(define-data-var next-resource-id uint u1)
(define-data-var next-training-id uint u1)

;; Create preparedness plan
(define-public (create-preparedness-plan
  (title (string-ascii 100))
  (disaster-type (string-ascii 30))
  (description (string-ascii 500))
  (priority uint)
)
  (let ((plan-id (var-get next-plan-id)))
    (asserts! (<= priority u5) ERR_INVALID_PRIORITY)

    (map-set preparedness-plans
      { plan-id: plan-id }
      {
        title: title,
        disaster-type: disaster-type,
        description: description,
        priority: priority,
        status: "draft",
        created-by: tx-sender,
        created-at: block-height,
        last-updated: block-height,
        next-review: (+ block-height u52560) ;; ~1 year in blocks
      }
    )
    (var-set next-plan-id (+ plan-id u1))
    (ok plan-id)
  )
)

;; Add resource to plan
(define-public (add-plan-resource
  (plan-id uint)
  (resource-type (string-ascii 50))
  (quantity-required uint)
  (quantity-available uint)
  (location (string-ascii 100))
  (contact-info (string-ascii 100))
)
  (let ((resource-id (var-get next-resource-id)))
    (match (map-get? preparedness-plans { plan-id: plan-id })
      plan-data
      (begin
        (map-set plan-resources
          { plan-id: plan-id, resource-id: resource-id }
          {
            resource-type: resource-type,
            quantity-required: quantity-required,
            quantity-available: quantity-available,
            location: location,
            contact-info: contact-info
          }
        )
        (var-set next-resource-id (+ resource-id u1))
        (ok resource-id)
      )
      ERR_PLAN_NOT_FOUND
    )
  )
)

;; Record training/drill
(define-public (record-training
  (plan-id uint)
  (training-type (string-ascii 50))
  (participants uint)
  (effectiveness-score uint)
  (notes (string-ascii 300))
)
  (let ((training-id (var-get next-training-id)))
    (match (map-get? preparedness-plans { plan-id: plan-id })
      plan-data
      (begin
        (map-set training-records
          { plan-id: plan-id, training-id: training-id }
          {
            training-type: training-type,
            participants: participants,
            date-conducted: block-height,
            effectiveness-score: effectiveness-score,
            notes: notes
          }
        )
        (var-set next-training-id (+ training-id u1))
        (ok training-id)
      )
      ERR_PLAN_NOT_FOUND
    )
  )
)

;; Update plan status
(define-public (update-plan-status (plan-id uint) (status (string-ascii 20)))
  (match (map-get? preparedness-plans { plan-id: plan-id })
    plan-data
    (begin
      (map-set preparedness-plans
        { plan-id: plan-id }
        (merge plan-data {
          status: status,
          last-updated: block-height
        })
      )
      (ok true)
    )
    ERR_PLAN_NOT_FOUND
  )
)

;; Get preparedness plan
(define-read-only (get-preparedness-plan (plan-id uint))
  (map-get? preparedness-plans { plan-id: plan-id })
)

;; Get plan resource
(define-read-only (get-plan-resource (plan-id uint) (resource-id uint))
  (map-get? plan-resources { plan-id: plan-id, resource-id: resource-id })
)

;; Get training record
(define-read-only (get-training-record (plan-id uint) (training-id uint))
  (map-get? training-records { plan-id: plan-id, training-id: training-id })
)
