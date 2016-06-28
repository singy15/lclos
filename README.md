
# lclos
the Light weight Common Lisp Object System.

###Features

* Create HashMap as Object
* Prototype based OOP

###How to use lclos

Load as a single file : (load "lclos.lisp").

* Create prototype object

```(defvar prot-test (new))```

* Define method

```(=< prot-test foo (lambda (this) (print "foo called")))```

```(=< prot-test fiz (lambda (this x y) (+ x y)))```

* Define attribute

```(=< prot-test bar 123)```

```(=< prot-test baz (new prot-test))```

* Create instance

```(defparameter test (new prot-test))```

* Call method

```(? test foo)```

```(? test fiz 2 3)```

* Get attribute

```(=> test bar)```

```(--> test 'baz 'bar)```

* Set attribute

```(=< test bar 456)```

```(--< test 'baz 'bar 456)```

* Inheritance

```(defvar prot-sub (new prot-test))```

```(defparameter test-sub (new prot-sub))```

```(? test-sub foo)```
