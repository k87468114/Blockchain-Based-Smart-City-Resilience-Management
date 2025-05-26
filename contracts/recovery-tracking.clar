;; Recovery Tracking Contract
;; Monitors post-disaster recovery progress

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_RECOVERY_NOT_FOUND (err u501))
(define-constant ERR_INVALID_PROGRESS (err u502))

;; Recovery projects
(define-map recovery-projects
  { project-id: uint }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    category: (string-ascii 30),
    priority: uint,
    budget-allocated: uint,
    budget-spent: uint,
    progress-percentage: uint,
    status: (string-ascii 20),
    start-date: uint,
    target-completion: uint,
    actual-completion: uint,
    project-manager: (string-ascii 50)
  }
)

;; Recovery milestones
(define-map recovery-milestones
  { project-id: uint, milestone-id: uint }
  {
    title: (string-ascii 100),
    description: (string-ascii 300),
    target-date: uint,
    completion-date: uint,
    status: (string-ascii 20),
    budget-portion: uint
  }
)

;; Impact assessments
(define-map impact-assessments
  { assessment-id: uint }
  {
    area: (string-ascii 100),
    damage-type: (string-ascii 50),
    severity: uint,
    estimated-cost: uint,
    people-affected: uint,
    infrastructure-affected: (string-ascii 200),
    assessed-by: principal,
    assessed-at: uint,
    status: (string-ascii 20)
  }
)

;; Counters
(define-data-var next-project-id uint u1)
(define-data-var next-milestone-id uint u1)
(define-data-var next-assessment-id uint u1)

;; Create recovery project
(define-public (create-recovery-project
  (title (string-ascii 100))
  (description (string-ascii 500))
  (category (string-ascii 30))
  (priority uint)
  (budget-allocated uint)
  (target-completion uint)
  (project-manager (string-ascii 50))
)
  (let ((project-id (var-get next-project-id)))
    (map-set recovery-projects
      { project-id: project-id }
      {
        title: title,
        description: description,
        category: category,
        priority: priority,
        budget-allocated: budget-allocated,
        budget-spent: u0,
        progress-percentage: u0,
        status: "planned",
        start-date: block-height,
        target-completion: target-completion,
        actual-completion: u0,
        project-manager: project-manager
      }
    )
    (var-set next-project-id (+ project-id u1))
    (ok project-id)
  )
)

;; Add milestone to project
(define-public (add-milestone
  (project-id uint)
  (title (string-ascii 100))
  (description (string-ascii 300))
  (target-date uint)
  (budget-portion uint)
)
  (let ((milestone-id (var-get next-milestone-id)))
    (match (map-get? recovery-projects { project-id: project-id })
      project-data
      (begin
        (map-set recovery-milestones
          { project-id: project-id, milestone-id: milestone-id }
          {
            title: title,
            description: description,
            target-date: target-date,
            completion-date: u0,
            status: "pending",
            budget-portion: budget-portion
          }
        )
        (var-set next-milestone-id (+ milestone-id u1))
        (ok milestone-id)
      )
      ERR_RECOVERY_NOT_FOUND
    )
  )
)

;; Update project progress
(define-public (update-project-progress
  (project-id uint)
  (progress-percentage uint)
  (budget-spent uint)
  (status (string-ascii 20))
)
  (begin
    (asserts! (<= progress-percentage u100) ERR_INVALID_PROGRESS)
    (match (map-get? recovery-projects { project-id: project-id })
      project-data
      (begin
        (map-set recovery-projects
          { project-id: project-id }
          (merge project-data {
            progress-percentage: progress-percentage,
            budget-spent: budget-spent,
            status: status,
            actual-completion: (if (is-eq progress-percentage u100) block-height u0)
          })
        )
        (ok true)
      )
      ERR_RECOVERY_NOT_FOUND
    )
  )
)

;; Complete milestone
(define-public (complete-milestone (project-id uint) (milestone-id uint))
  (match (map-get? recovery-milestones { project-id: project-id, milestone-id: milestone-id })
    milestone-data
    (begin
      (map-set recovery-milestones
        { project-id: project-id, milestone-id: milestone-id }
        (merge milestone-data {
          completion-date: block-height,
          status: "completed"
        })
      )
      (ok true)
    )
    ERR_RECOVERY_NOT_FOUND
  )
)

;; Create impact assessment
(define-public (create-impact-assessment
  (area (string-ascii 100))
  (damage-type (string-ascii 50))
  (severity uint)
  (estimated-cost uint)
  (people-affected uint)
  (infrastructure-affected (string-ascii 200))
)
  (let ((assessment-id (var-get next-assessment-id)))
    (map-set impact-assessments
      { assessment-id: assessment-id }
      {
        area: area,
        damage-type: damage-type,
        severity: severity,
        estimated-cost: estimated-cost,
        people-affected: people-affected,
        infrastructure-affected: infrastructure-affected,
        assessed-by: tx-sender,
        assessed-at: block-height,
        status: "active"
      }
    )
    (var-set next-assessment-id (+ assessment-id u1))
    (ok assessment-id)
  )
)

;; Get recovery project
(define-read-only (get-recovery-project (project-id uint))
  (map-get? recovery-projects { project-id: project-id })
)

;; Get milestone
(define-read-only (get-milestone (project-id uint) (milestone-id uint))
  (map-get? recovery-milestones { project-id: project-id, milestone-id: milestone-id })
)

;; Get impact assessment
(define-read-only (get-impact-assessment (assessment-id uint))
  (map-get? impact-assessments { assessment-id: assessment-id })
)

;; Calculate overall recovery progress
(define-read-only (calculate-recovery-progress (project-id uint))
  (match (map-get? recovery-projects { project-id: project-id })
    project-data
    (ok {
      progress: (get progress-percentage project-data),
      budget-utilization: (if (> (get budget-allocated project-data) u0)
        (/ (* (get budget-spent project-data) u100) (get budget-allocated project-data))
        u0
      ),
      days-elapsed: (- block-height (get start-date project-data)),
      on-schedule: (<= block-height (get target-completion project-data))
    })
    ERR_RECOVERY_NOT_FOUND
  )
)
