
;; Light weight Common Lisp Object System (LCLOS)

;; prototype key
(defvar +prototype+ 'prototype)
;; initialize function key
(defvar +initialize+ 'initialize)

;; make new object by designated prototype
(defun new (&optional (prot nil))
  (let ((obj (make-hash-table :test #'equal)))
    (if prot
        (setf (gethash +prototype+ obj) prot)
        (setf (gethash +prototype+ obj) +object+))
    (initialize-obj obj) obj))

;; get property
(defun getv (ht key)
  (gethash key ht))

;; get property
(defun -> (ht sym)
  (gethash key ht))

;; get property short
(defmacro => (ht sym)
  `(gethash ',sym ,ht))

;; set property
(defun setv (ht key val)
  (setf (gethash key ht) val))

;; set property (short)
(defun -< (ht key val)
  (setf (gethash key ht) val))

;; set property (short)
(defmacro =< (ht sym val)
  `(setf (gethash ',sym ,ht) ,val))

;; call method
(defmacro send (ht sym &rest vals)
  `(funcall (lookup ,ht ',sym) ,ht ,@vals))

;; call method (short)
(defmacro ? (ht sym &rest vals)
  `(funcall (lookup ,ht ',sym) ,ht ,@vals))

;; call super
(defmacro super (ht sym &rest vals)
  `(funcall (lookup (gethash +prototype+ (gethash +prototype+ ,ht)) ',sym) ,ht ,@vals))

;; call initialize cascade
(defun initialize-obj (ht)
  (let ((fnls (reverse (lookup-chain ht +initialize+))))
    (mapcar
      (lambda (fn)
        (if fn (funcall fn ht) nil))
      fnls)))

;; property or method lookup
(defun lookup (ht sym)
  (if ht
    (if (nth-value 1 (gethash sym ht))
      (gethash sym ht)
      (lookup (gethash +prototype+ ht) sym))
    (error "no property or method found")))

;; lookup for prototype chain
(defun lookup-chain (ht sym)
  (labels (
    (lookup-chain-1 (ht sym ls)
      (if (gethash +prototype+ ht)
         (lookup-chain-1 (gethash +prototype+ ht) sym (append ls (list (gethash sym ht))))
         (append ls (list (gethash sym ht))))))
    (lookup-chain-1 ht sym (list))))

;; set cascade
(defun setc (ht &rest sym-val)
  (labels (
    (lookup-casc-1 (ht syms)
      (if (> (length syms) 1)
        (if (nth-value 1 (gethash (first syms) ht))
          (lookup-casc-1 (gethash (first syms) ht) (rest syms))
          (error "no property or method found"))
        (setf (gethash (first syms) ht) (car (reverse sym-val))))))
    (lookup-casc-1 ht (reverse (cdr (reverse sym-val))))))

;; set cascade (short)
(defun --< (ht &rest sym-val)
  (labels (
    (lookup-casc-1 (ht syms)
      (if (> (length syms) 1)
        (if (nth-value 1 (gethash (first syms) ht))
          (lookup-casc-1 (gethash (first syms) ht) (rest syms))
          (error "no property or method found"))
        (setf (gethash (first syms) ht) (car (reverse sym-val))))))
    (lookup-casc-1 ht (reverse (cdr (reverse sym-val))))))

;; get cascad
(defun getc (ht &rest sym)
  (labels (
    (lookup-casc-1 (ht syms)
      (if (> (length syms) 1)
        (if (nth-value 1 (gethash (first syms) ht))
          (lookup-casc-1 (gethash (first syms) ht) (rest syms))
          (error "no property or method found"))
        (gethash (first syms) ht))))
    (lookup-casc-1 ht sym)))

;; get cascade (short)
(defun --> (ht &rest sym)
  (labels (
    (lookup-casc-1 (ht syms)
      (if (> (length syms) 1)
        (if (nth-value 1 (gethash (first syms) ht))
          (lookup-casc-1 (gethash (first syms) ht) (rest syms))
          (error "no property or method found"))
        (gethash (first syms) ht))))
    (lookup-casc-1 ht sym)))

;-------------------------------------------------
; preset class
(defvar +object+ (make-hash-table :test #'equal))
(-< +object+ +initialize+
  (lambda (this)
    (-< this 'this this)))

; preset method to-string
(=< +object+ to-string
  (lambda (this)
    "object"))
