#lang racket/base
(require (for-syntax racket/base syntax/parse))

;;;; Self
;; self是对象对自身的引用，函数对自身的引用自然就是递归函数要表达的东西了。
;; 虽说在其他常见对象系统里，对象是用“结构体”和“方法表”组合出来的，考虑起来会稍有不同。

;; 当前的实现里，self在对象创建之后就是固定的了

(begin-for-syntax
  (define (make-seters names)
    (datum->syntax
     #f (for/list ([n (in-list (syntax-e names))])
          (datum->syntax n (string->symbol (format "~a!" (syntax->datum n))) n n)))))

(define-syntax (object stx)
  (syntax-parse stx
    [(_ ([fname init] ...)
        ([mname args body] ...))
     (with-syntax ([self (datum->syntax stx 'self)]
                   [(fname! ...) (make-seters #'(fname ...))])
       #'(letrec ([self
                   (let ([fname init] ...)
                     (let ([methods (list (cons 'fname (λ () fname)) ...
                                          (cons 'fname! (λ (new) (set! fname new))) ...
                                          (cons 'mname (λ args body)) ...)])
                       (λ (msg . vals)
                         (let ([m (assoc msg methods)])
                           (if m
                               (apply (cdr m) vals)
                               (error "unknown methods:" msg))))))])
           self))]))

(define-syntax-rule (-> obj method args ...)
  (obj 'method args ...))

;;;; Test0
(define (make-point x y)
  (object ([x x] [y y])
          ((above (p)
                  (if (> (-> p y) y)
                      p
                      self)))))

#; (-> (-> (make-point 0 0) above (make-point 0 1)) y)

;;;; Test1
(define odd-even
  (object ()
          ((odd? (n) (case n
                       [(0) #f]
                       [(1) #t]
                       [else (-> self even? (sub1 n))]))
           (even? (n) (case n
                        [(0) #t]
                        [(1) #f]
                        [else (-> self odd? (sub1 n))])))))

;; 得益于Scheme的词法作用域和尾递归优化
#; (-> odd-even odd? 120000001)

