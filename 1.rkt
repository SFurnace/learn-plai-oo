#lang racket/base
(require (for-syntax racket/base syntax/parse))

(define-syntax (object stx)
  (syntax-parse stx
    [(_ ([fname init] ...)
        ([mname args body] ...))
     #'(let ([fname init] ...)
         (let ([methods (list (cons 'mname (λ args body)) ...)])
           (λ (msg . vals)
             (apply (cdr (assoc msg methods)) vals))))]))

(define point
  (object ([x 0] [y 0])
          ((x () x)
           (y () y)
           (x! (new-x) (set! x new-x))
           (y! (new-y) (set! y new-y)))))
