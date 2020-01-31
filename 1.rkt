#lang racket/base
(require (for-syntax racket/base syntax/parse))

;;;; 对象系统能力（仅分析这种实现）
;; v0.1
;; 1. 对象，整合了一些“状态”和“方法”的闭包
;; 2. 动态配发，通过运行时查询对象上的的方法表来派发消息
;; 3. 构造函数，对“对象”这种闭包的高阶函数
;;
;; 如此说来，在没有一类函数的语言里，有“functor”这种模式，用来有限地模仿闭包
;; 这其中有些对应的东西

(define-syntax (object stx)
  (syntax-parse stx
    [(_ ([fname init] ...)
        ([mname args body] ...))
     #'(let ([fname init] ...)
         (let ([methods (list (cons 'mname (λ args body)) ...)])
           (λ (msg . vals)
             (let ([m (assoc msg methods)])
               (if m
                   (apply (cdr m) vals)
                   (error "unknown methods:" msg))))))]))

(define-syntax-rule (-> obj method args ...)
  (obj 'method args ...))


(module+ test
  
  (define point
    (object ([x 0] [y 0])
            ((x () x)
             (y () y)
             (x! (new-x) (set! x new-x))
             (y! (new-y) (set! y new-y)))))

  (-> point x)

  )
