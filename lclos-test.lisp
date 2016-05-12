
;;; load libraries
(load "./lclos.lisp")

(ql:quickload :lisp-unit)
(use-package 'lisp-unit)

;; can new object
(define-test can-new-object 
  (assert-true (not (equal (new) nil))))

;; can setv getv
(define-test can-setv-getv
  (let ((o (new)))
    (setv o 'a 1234)
    (assert-true (equal (getv o 'a) 1234))))

;; can =< =>
(define-test can-=>-=<
  (let ((o (new)))
    (=< o a 1234)
    (assert-true (equal (=> o a) 1234))))

;; can setc getc
(define-test can-setc-getc
  (let ((o (new)))
    (=< o a (new))
    (setc o 'a 'b 123)
    (assert-true (equal (getc o 'a 'b) 123))))

;; can --> --<
(define-test can---<--->
  (let ((o (new)))
    (=< o a (new))
    (--< o 'a 'b 123)
    (assert-true (equal (--> o 'a 'b) 123))))

;; can new object by prototype
(define-test can-new-by-prot
  (let ((prot (new)))
    (=< prot test (lambda (this x y) (+ x y)))
    (let ((o (new prot)))
      (assert-equal (send o test 1 2) 3))))

;; can send
(define-test can-send
  (let ((prot (new)))
    (=< prot test (lambda (this x y) (+ x y)))
    (let ((o (new prot)))
      (assert-equal (send o test 1 2) 3))))

;; can ?
(define-test can-?
  (let ((prot (new)))
    (=< prot test (lambda (this x y) (+ x y)))
    (let ((o (new prot)))
      (assert-equal (? o test 1 2) 3))))

;; can to-string
(define-test can-to-string
  (let ((o (new)))
    (assert-equal (? o to-string) "object")))
