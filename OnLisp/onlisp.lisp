;; This is comment line.
;; The lisp file is the lesson file for practicing ccommon lisp --- reading <On Lisp> by Tabuyos

#|
	Chapter 1.
	Extensible language.
|#

;; Bottom-up Design
;; AI: Artificial Intelligence

#|
	Chapter 2.
	Functions.
|#

(defun double2 (x) (* x 2))

(double2 2)

#'double2

;; (defun double (x) (* x 2)) === (setf (symbol-function 'double) #'(lambda (x) (* x 2)))

(apply '+ '(1 2))
(apply #'+ '(1 2))

(funcall '+ 1 2)
(funcall #'+ 1 2)

(mapcar #'(lambda (x y) (+ x 10 y)) '(1 2 3) '(4 5 6)) ;; can't remove #
(mapcar #'+ '(1 2 3 4) '(4 5 6))
(mapcar '+ '(1 2 3 4) '(4 5 6))

(remove-if #'evenp '(1 2 3 4 5 6 7))

;; our function for remove-if
(defun our-remove-if (fn lst)
	(if (null lst)
		nil
		(if (funcall fn (car lst))
			(our-remove-if fn (cdr lst))
			(cons (car lst) (our-remove-if fn (cdr lst))))))

(our-remove-if #'evenp '(1 2 3 4 5 6 7))

(defun behave (animal)
	(case animal
		(dog (wag-tail)
			(bark))
		(rat (scurry)
			(squeak))
		(cat (rub-legs)
			(scratch-carpet))))

(behave 'dog)

(setf (get 'dog 'buhavior)
	#'(lambda ()
		  (wag-tail)
		  (bark)))

(defun behave (animal)
	(funcall (get animal 'behavior)))

(behave 'dog)

(defun list+ (lst n)
	(mapcar #'(lambda (x) (+ x n))
		lst))

(list+ '(1 2 3 4) 11)

(let ((y 7))
	(defun scope-test (x) (list x y)))

(scope-test 3)

(defun make-adder (n)
	#'(lambda (x) (+ x n)))

(setq add2 (make-adder 2)
	add10 (make-adder 10))

(add2 5) ;; error
(funcall add2 5)

(defun make-adderb (n)
	#'(lambda (x &optional change)
		  (if change
			  (setq n x)
			  (+ x n))))

(setq addx (make-adderb 1))

(funcall addx 3)

(funcall addx 100 t)

(defun make-dbms (db)
	(list
		#'(lambda (key)
			  (cdr (assoc key db)))
		#'(lambda (key val)
			  (push (cons key val) db)
			  key)
		#'(lambda (key)
			  (setf db (delete key db :key #'car))
			  key)))

(setq cities (make-dbms '((boston . us) (paris . france))))

(funcall (car cities) 'boston)
(funcall (second cities) 'london 'england)
(funcall (car cities) 'london)

(defun lookup (key db)
	(funcall (car db) key))

(labels ((inc (x) (1+ x)))
	(inc 3))

(defun count-instances (obj lsts)
	(labels ((instances-in (lst)
				 (format t "~A ~A~%" obj lst)
				 (if (consp lst)
					 (+ (if (eq (car lst) obj) 1 0)
						 (instances-in (cdr lst)))
					 0)))
		(mapcar #'instances-in lsts)))

(count-instances 'a '((a b c) (d a r p a) (d a r) (a a)))

;; non-tail-recursive
(defun our-length (lst)
	(if (null lst)
		0
		(1+ (out-length (cdr lst)))))

(1+ (1+ (1+ 0)))

;; tail-recursive
(defun our-find-if (fn lst)
	(format t "~A~%" lst)
	(if (funcall fn (car lst))
		(car lst)
		(our-find-if fn (cdr lst))))

(our-find-if #'evenp '(1 3 4 5 6 7 8 9))

;; tail-recursive
(defun our-length (lst)
	(labels ((rec (lst acc)
				 (if (null lst)
					 acc
					 (rec (cdr lst) (1+ acc)))))
		(rec lst 0)))

(our-length '(1 2 3 4 5 3 2 2 2))

(defun triangle (n)
	(labels ((tri (c n)
				 (declare (type fixnum n c))
				 (if (zerop n)
					 c
					 (tri (the fixnum (+ c n))
						 (the fixnum (- n 1))))))
		(tri 0 n)))

(triangle 10000)

(compiled-function-p #'triangle)

(defun 50th (lst) (nth 49 lst))

(proclaim '(inline 50th))

(defun foo (lst)
	(+ (50th lst) 1))

#|
	Chapter 3.
	Functional programming.
|#

(setq lst '(a b c))

(defun bad-reverse (lst)
	(let* ((len (length lst))
			  (ilimit (truncate (/ len 2))))
		(do ((i 0 (1+ i))
				(j (1- len) (1- j)))
			((>= i ilimit))
			(rotatef (nth i lst) (nth j lst)))))

(bad-reverse lst)

lst

(do ((i 0 (1+ i)) (j 10 (1- j))) ((= i j)) (format t "i=~A j=~A~%" i j))

(defun good-reverse (lst)
	(labels ((rev (lst acc)
				 (if (null lst)
					 acc
					 (rev (cdr lst) (cons (car lst) acc)))))
		(rev lst nil)))

;; lst won't change
(good-reverse lst)

lst

(reverse lst)

(nreverse lst)

(truncate (/ 3 2))

(multiple-value-bind (int frac) (truncate (/ 3 2)) (list int frac))

(nth 3 '(a b c d e))

(nth 1 '(a b c d e))

(nth 8 '(a b c d e))

;; get multiple value by use values symbol
(defun powers (x)
	(values x (sqrt x) (expt x 2)))

(powers 4)

;; result
(defun fun (x)
	(list 'a (expt (car x) 2)))

(fun '(3 4))

;; processing
(defun imp (x)
	(let (y sqr)
		(setq y (car x))
		(setq sqr (expt y 2))
		(list 'a sqr)))

(imp '(3 4))

(defun qualify (expr)
	(nconc (copy-list expr) (list 'maybe)))

(qualify lst)

lst

(let ((x 0))
	(defun total (y)
		(incf y x)))

(total 9)

(let ((x 0)) 
	(defun total (y)
		(incf x y)))

(total 9)

(defun ok (x)
	(nconc (list 'a x) (list 'c)))

(ok 3)

(defun not-ok (x)
	(nconc (list 'a) x (list 'c)))

(not-ok '(4))

(defun anything (x)
	(+ x *anything*))

(anything 4)

(defun f (x)
	(let ((val (g x)))
		;; safe to modify val here?
		))

(defun exclaim (expression)
	(append expression '(on my)))

(exclaim '(lions and tigers and bears))

(nconc * '(goodness))

(exclaim '(fixnums and begnums and floats))

#|
	Chapter 4.
	Utility functions.
|#

(defun all-nicknames (names)
	(if (null names)
		nil
		(nconc (nicknames (car names))
			(all-nicknames (cdr names)))))

(mapcan #'nicknames people)

(let ((town (find-if #'bookshops towns)))
	(calues town (bookshops town)))

(defun find-books (towns)
	(if (null towns)
		nil
		(let ((shops (bookshops (car towns))))
			(if shops
				(values (car towns) shops)
				(find-books (cdr towns))))))

(defun find2 (fn lst)
	(if (null lst)
		nil
		(let ((val (funcall fn (car lst))))
			(if val
				(values (car lst) val)
				(find2 fn (cdr lst))))))

(proclaim '(inline last1 single append1 conc1 mklist))

(defun last1 (lst)
	(car (last lst)))

(defun single (lst)
	(and (consp lst) (not (cdr lst))))

(defun append1 (lst obj)
	(append lst (list obj)))

(defun conc1 (lst obj)
	(nconc lst (list obj)))

(defun mklist (object)
	(if (listp obj) obj (list obj)))

(defun longer (x y)
	(labels ((compare (x y)
				 (and (consp x)
					 (or (null y)
						 (compare (cdr x) (cdr y))))))
		(if (and (listp x) (listp y))
			(compare x y)
			(> (length x) (length y)))))

(defun filter (fn lst)
	(let ((acc nil))
		(dolist (x lst)
			(let ((val (funcall fn x)))
				(if val (push val acc))))
		(nreverse acc)))

(defun group (source n)
	(if (zerop n) (error "zero length"))
	(labels ((rec (source acc)
				 (let ((rest (nthcdr n source)))
					 (if (consp rest)
						 (rec rest (cons (subseq source 0 n) acc))
						 (nreverse (cons source acc))))))
		(if source (rec source nil) nil)))

(last1 "blub") ;; error

(append1 lst 'd)

(consp lst)

(listp lst)

(conc1 lst 'd)

(group '(a b c d e f g h i j k l m n) 3)

(defun flatten (x)
	(labels ((rec (x acc)
				 (cond ((null x) acc)
					 ((atom x) (cons x acc))
					 (t (rec (car x) (rec (cdr x) acc))))))
		(rec x nil)))

(defun prune (test tree)
	(labels ((rec (tree acc)
				 (cond ((null tree) (nreverse acc))
					 ((consp (car tree))
						 (rec (cdr tree)
							 (cons (rec (car tree) nil) acc)))
					 (t (rec (cdr tree)
							(if (funcall test (car tree))
								acc
								(cons (car tree) acc)))))))
		(rec tree nil)))

(defun find2 (fn lst)
	(if (null lst)
		nil
		(let ((val (funcall fn (car lst))))
			(if val
				(values (car lst) val)
				(find2 fn (cdr lst))))))

(defun before (x y lst &key (test #'eql))
	(and lst
		(let ((first (car lst)))
			(cond ((funcall test y first) nil)
				((funcall test x first) lst)
				(t (before x y (cdr lst) :test test))))))

(defun duplicate (obj lst &key (test #'eql))
	(member obj (cdr (member obj lst :test test))
		:test test))
(defun split-if (fn lst)
	(let ((acc nil))
		(do ((src lst (cdr src)))
			((or (null src) (funcall fn (car src)))
				(values (nreverse acc) src))
			(push (car src) acc))))

(before 'a 'b '(a d))

(duplicate 'a '(a b c a d))

(member 'b '(a b c d a d d e ) :test #'eql)

(split-if #'(lambda (x) (> x 4)) '(1 2 3 4 5 6 7 8 9 10))

(multiple-value-bind (first second) (split-if #'(lambda (x) (> x 4)) '(1 2 3 4 5 6 7 8 9 10)) (list first second))

(defun most (fn lst)
	(if (null lst)
		(values nil nil)
		(let* ((wins (car lst))
				  (max (funcall fn wins)))
			(dolist (obj (cdr lst))
				(let ((score (funcall fn obj)))
					(when (> score max)
						(setq wins obj max score))))
			(values wins max))))

(defun best (fn lst)
	(if (null lst)
		nul
		(let ((wins (car lst)))
			(dolist (obj (cdr lst))
				(if (funcall fn obj wins)
					(setq wins obj)))
			wins)))

(defun mostn (fn lst)
	(if (null lst)
		(values nil nil)
		(let ((rsult (list (car lst)))
				 (max (funcall fn (car lst))))
			(dolist (obj (cdr lst))
				(let ((score (funcall fn obj)))
					(cond ((> score max)
							  (setq max score result (list obj)))
						((= score max)
							(push obj result)))))
			(values (nreverse result) max))))

(best #'> '(1 2 3 4 9 6 7 9 8))

(mostn #'length '((a b) (a b c) (a d) (e f g h)))

(defun map0-n (fn n)
	(mapa-b fn 0 n))

(defun map1-n (fn n)
	(mapa-b fn 1 n))

(defun mapa-b (fn a b &optional (step 1))
	(do ((i a (+ i step))
			(result nil))
		((> i b) (nreverse result))
		(push (funcall fn i) result)))

(map0-n #'1+ 5)

(map1-n #'1+ 5)

(defun map-> (fn start test-fn succ-fn)
	(do ((i start (funcall succ-fn i))
			(result nil))
		((funcall test-fn i) (nreverse result))
		(push (funcall fn i) result)))

(do ((i 0 (1+ i))) ((= i 6)) (format t "~A~%" i))

(defun mapcars (fn &rest lsts)
	(let ((result nil))
		(dolist (lst lsts)
			(dolist (obj lst)
				(push (funcall fn obj) result)))
		(nreverse result)))

;; rmapcar: recursive mapcar
(defun rmapcar (fn &rest args)
	(if (some #'atom args)
		(apply fn args)
		(apply #'mapcar #'(lambda (&rest args)
							  (apply #'rmapcar fn args))
			args)))

(mapcars #'sqrt '(1 2 3) '(4 5 6 7) '(8) '(9))

(rmapcar #'sqrt '(1 2 3 (4 5 (6 7 8 (9)))))

(some #'atom '(1 (2)))

(defun readlist (&rest args)
	(values (read-from-string (concatenate 'string "(" (apply #'read-line args) ")"))))

(defun prompt (&rest args)
	(apply #'format *query-io* args)
	(read *query-io*))

(defun break-loop (fn quit &rest args)
	(format *query-io* "Entering break-loop. '~%")
	(loop
		(let ((in (apply #'prompt args)))
			(if (funcall quit in)
				(return)
				(format *query-io* "~A~%" (funcall fn in))))))

(readlist)

(values 1 2 3)

(prompt "Entering a number between ~A and ~A ~% >> "1 10)

(defun mkstr (&rest args)
	(with-output-to-string (s)
		(dolist (a args) (princ a s))))

(defun symb (&rest args)
	(values (intern (apply #'mkstr args))))

(defun reread (&rest args)
	(values (read-from-string (apply #'mkstr args))))

(defun explode (sym)
	(map 'list #'(lambda (c)
					 (intern (make-string 1 :initial-element c)))
		(symbol-name sym)))

(mkstr pi " pieces of " 'pi)

(symb 'ar "Madi" #\L #\L 0)

(symb '(a b))

(let ((s (symb '(a b))))
	(and (eq s '|(A B)|) (eq s '\(A\ B\))))

(explode 'tabuyos)

(symbol-name 'tabuyos)

#|
	Chapter 5.
	Returning functions.
|#

(remove-if-not #'evenp '(1 2 3 4 5 6))

(remove-if (complement #'evenp) '(1 2 3 4 5 6))

(defun joiner (obj)
	(typecase obj
		(cons #'append)
		(number #'+)))

;; polymorphic -> join
(defun join (&rest args)
	(apply (joiner (car args)) args))

(join 1 2 3)

(defun make-adder (n)
	#'(lambda (x) (+ x n)))

(setq add3 (make-adder 3))

(funcall add3 2)

(defun my-complement (fn)
	#'(lambda (&rest args) (not (apply fn args))))

(remove-if (my-complement #'evenp) '(1 2 3 4 5 6))

(defvar *!equivs* (make-hash-table))

(defun ! (fn)
	(or (gethash fn *!equivs*)fn))

(defun def! (fn fn!)
	(setf (gethash fn *!equivs*) fn!))

(def! #'remove-if #'delete-if)

(setq lst '(1 2 3 4 5 6 7))

(delete-if #'oddp lst)

(funcall (! #'remove-if) #'oddp lst)

(defun memoize (fn)
	(let ((cache (make-hash-table :test #'equal)))
		#'(lambda (&rest args)
			  (multiple-value-bind (val win) (gethash args cache)
				  (if win
					  val
					  (setf (gethash args cache)
						  (apply fn args)))))))

(setq slowid (memoize #'(lambda (x) (sleep 5) x)))

(time (funcall slowid 1))

(time (funcall slowid 1))

(time (funcall slowid 7))

(time (funcall slowid 7))

(defun compose (&rest fns)
	(if fns
		(let ((fn1 (car (last fns)))
				 (fns (butlast fns)))
			#'(lambda (&rest args)
				  (reduce #'funcall fns
					  :from-end t
					  :initial-value (apply fn1 args))))
		#'identity))

(funcall (compose #'list #'1+) 1)

(funcall (compose #'1+ #'find-if) #'oddp '(2 3 4))

(funcall (compose #'1+ #'find-if) #'oddp '(2 9 4))

(defun my-complement (pred)
	(compose #'not pred))

(mapcar #'(lambda (x)
			  (if (slave x)
				  (owner x)
				  (employer x)))
	people)

(defun fif (if then &optional else)
	#'(lambda (x)
		  (if (funcall if x)
			  (funcall then x)
			  (if else (funcall else x)))))

(defun fint (fn &rest fns)
	(if (null fns)
		fn
		(let ((chain (apply #'fint fns)))
			#'(lambda (x)
				  (and (funcall fn x) (funcall chain x))))))

(defun fun (fn &rest fns)
	(if (null fns)
		fn
		(let ((chain (apply #'fun fns)))
			#'(lambda (x)
				  (or (funcall fn x) (funcall chain x))))))

(find-if #'(lambda (x)
			   (and (signed x) (sealed x) (delivered x)))
	docs)

;; equal
(find-if (fint #'signed #'sealed #'delivered) docs)

(defun our-length (lst)
	(if (null lst)
		0
		(1+ (our-length (cdr lst)))))

(defun our-every (fn lst)
	(if (null lst)
		t
		(and (funcall fn (car lst))
			(our-every fn (cdr lst)))))

(our-every #'oddp '(1 3 5 6))

(defun lrec (rec &optional base)
	(labels ((self (lst)
				 (if (null lst)
					 (if (functionp base)
						 (funcall base)
						 base)
					 (funcall rec (car lst)
						 #'(lambda ()
							   (self (cdr lst)))))))
		#'self))

;; lrec's first argument must be function that can be capture two arguments that car of list and function

;; our-length
(lrec #'(lambda (x f) (1+ (funcall f))) 0)

;; our-every
(lrec #'(lambda (x f) (and (oddp x) (funcall f))) t)

(functionp t)

(functionp nil)

;; copy-list
(lrec #'(lambda (x f) (cons x (funcall f))))

;; remove-duplicates
(lrec #'(lambda (x f) (adjoin x (funcall f))))

;; find-if, for some function fn
(lrec #'(lambda (x f) (if (fn x) x (funcall f))))

;; some, for some function fn
(lrec #'(lambda (x f) (or (fn x) (funcall f))))

(setq x '(a b)
	listx (list x 1))

(eq x (car (copy-list listx)))  ;; t

(eq x (car (copy-tree listx))) ;; nil

(eq (car (copy-list listx)) (car (copy-tree listx)))

(car (copy-list listx))

(car (copy-tree listx))

(defun out-copy-tree (tree)
	(if (atom tree)
		tree
		(cons (our-copy-tree (car tree))
			(if (cdr tree) (our-copy-tree (cdr tree))))))

(defun count-leaves (tree)
	(if (atom tree)
		1
		(+ (count-leaves (car tree))
			(or (if (cdr tree) (count-leaves (cdr tree))) 1))))

(count-leaves '(a b (c d) (e)))

(count-leaves '((a b (c d)) (e) f))

'((a . (b . ((c . (d . nil)) . nil))) . ((e . nil) . (f . nil)))

(count-leaves '(a b))

(defun rfind-if (fn tree)
	(if (atom tree)
		(and (funcall fn tree) tree)
		(or (rfind-if fn (car tree))
			(if (cdr tree) (rfind-if fn (cdr tree))))))

(rfind-if (fint #'numberp #'oddp) '(2 (3 4) 5))

#|
	Chapter 6.
	Functions as Representation.
|#

(defstruct node contents yes no)

(defvar *nodes* (make-hash-table))

(defun defnode (name conts &optional yes no)
	(setf (gethash name *nodes*)
		(make-node :contents conts
			:yes yes
			:no no)))

(defnode 'people "Is the person a man?" 'male 'female)

(defnode 'male "Is he living?" 'liveman 'deadman)

(defnode 'deadman "Was he American?" 'us 'them)

(defnode 'us "Is he on a coin?" 'coin 'cidence)

(defnode 'coin "Is the coin penny?" 'penny 'coins)

(defnode 'penny 'lincoln)

(defun run-node (name)
	(let ((n (gethash name *nodes*)))
		(cond ((node-yes n)
				  (format t "~A~%>> " (node-contents n))
				  (case (read)
					  (yes (run-node (node-yes n)))
					  (t (run-node (node-no n)))))
			(t (node-contents n)))))

(run-node 'people)

(setq n (compile-net 'people))

#|
	Chapter 7.
	Macros.
|#

(defmacro nil! (var)
	(list 'setq var nil))

(nil! x)

(defmacro nil! (var)
	`(setq ,var nil))

;; use backquote
(defmacro nif (expr pos zero neg)
	`(case (truncate (signum ,expr))
		 (1 ,pos)
		 (0 ,zero)
		 (-1 ,neg)))

;; use non-backquote
(defmacro nif (expr pos zero neg)
	(list 'case
		(list 'truncate (list 'signum expr))
		(list 1 pos)
		(list 0 zero)
		(list -1 neg)))

(mapcar #'(lambda (x)
			  (nif x 'p 'z 'n))
	'(0 2.5 -8))

(case (truncate (signum 2))
	(1 'p)
	(0 'z)
	(-1 'n))

(setq b '(1 2 3))

`(a ,b c) ;; (A (1 2 3) C)

`(a ,@b c) ;; (A 1 2 3 C)

`(a ,@1)

(defun greet (name)
	`(hello ,name))

(greet "tabuyos")

;; macro expand for nil!
(macroexpand-1 '(nil! x))

(member x choices :test #'eq)

(defmacro memq (obj lst)
	`(member ,obj ,lst :test #'eq))

(defmacro my-memq (obj lst)
	(list 'member obj lst ':test '#'eq))

(macroexpand-1 '(my-memq x choices))

(defmacro my-while (test &body body)
	`(do ()
		 ((not ,test))
		 ,@body))

(pprint (macroexpand '(my-while (able) (laugh))))

(defmacro mac (expr)
	`(pprint (macroexpand-1 ',expr)))

(mac (or x y))

(mac (nil! x))

(multiple-value-bind (exp bool) (macroexpand-1 '(memq 'a '(a b c))) (setq gexp exp))

gexp

(eval gexp)

;; destructuring
(defun foo (x y z)
	(+ x y z))

(foo 1 2 3)

(destructuring-bind (x (y) . z) '(a (b) c d)
	(list x y z))

(mac '(dolist (x '(a b c)) (print x)))

(dolist (x '(a b c)) (print x))

(defmacro our-dolist ((var list &optional result) &body body)
	`(progn
		 (mapc #'(lambda (,var) ,@body) ,list)
		 (let ((,var nil)) ,result)))

(mac '(our-dolist (x '(a b c)) (print x)))

(mapc #'(lambda (x) (print x)) '(a b c))

(let ((x nil)) t)

(defmacro when-bind ((var expr) &body body)
	`(let ((,var ,expr))
		 (when ,var ,body)))

(when-bind (input (get-user-input))
	(process input))
