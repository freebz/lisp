;���� ǳ�� �����ϱ�
(defparameter *nodes* '((living-room (you are in the living-room.
				      a wizard is snoring loudly on the couch.))
			 (garden (you are in a beautiful garden.
				      there is a well in front of you.))
			 (attic (you are in the attic.
				     there is a giant welding torch in the corner.))))

;��� �����ϱ�
(defun describe-location (location nodes)
  (cadr (assoc location nodes)))

;��� �����ϱ�
(defparameter *edges* '((living-room (garden west door)
			 (attic upstairs ladder))
			(garden (living-room east door))
			(attic (living-room downstairs ladder))))

(defun describe-path (edge)
  `(there is a ,(caddr edge) going ,(cadr edge) from here.))

;�� ���� ���� ��� �����ϱ�
(defun describe-paths (location edges)
  (apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))

;Ư�� ����� ���� �����ϱ�
;���� ���̴� ���� �����ϱ�
(defparameter *objects* '(whiskey bucket frog chain))
(defparameter *object-locations* '((whiskey living-room)
				    (bucket living-room)
				    (chain garden)
				    (frog garden)))

(defun objects-at (loc objs obj-locs)
  (flet ((at-loc-p (obj)
	     (eq (cadr (assoc obj obj-locs)) loc)))
    (remove-if-not #'at-loc-p objs)))

;���� ���̴� ���� �����ϱ�
(defun describe-objects (loc objs obj-loc)
  (flet ((describe-obj (obj)
	   `(you see a ,obj on the floor.)))
    (apply #'append (mapcar #'describe-obj (objects-at loc objs obj-loc)))))

;���� ����ϱ�
(defparameter *location* 'living-room)

(defun look ()
  (append (describe-location *location* *nodes*)
	  (describe-paths *location* *edges*)
	  (describe-objects *location* *objects* *object-locations*)))

;���� ���� �ѷ�����
(defun walk (direction)
  (let ((next (find direction
		    (cdr (assoc *location* *edges*))
		    :key #'cadr)))
    (if next
	(progn (setf *location* (car next))
	       (look))
	'(you cannot go that way.))))

;���� ����
(defun pickup (object)
  (cond ((member object
		 (objects-at *location* *objects* *object-locations*))
	 (push (list object 'body) *object-locations*)
	 `(you are now carrying the ,object))
	(t '(you cannot get that.))))

;������ Ȯ���ϱ�
(defun inventory ()
  (cons 'items- (objects-at 'body *objects* *object-locations*)))

;���� ������ ���� ���� �������̽� �߰��ϱ�
;���� ����� REPL
;(defun game-repl ()
;  (loop (print (eval (read)))))

;���� ����� �߰�
(defun game-repl ()
  (let ((cmd (game-read)))
    (unless (eq (car cmd) 'quit)
      (game-print (game-eval cmd))
      (game-repl))))

;read �Լ� ���� �ۼ��ϱ�
(defun game-read ()
  (let ((cmd (read-from-string
	      (concatenate 'string "(" (read-line) ")"))))
    (flet ((quote-it (x)
	     (list 'quote x)))
      (cons (car cmd) (mapcar #'quote-it (cdr cmd))))))

;game-eval �Լ� �ۼ��ϱ�
(defparameter *allowed-commands* '(look walk pickup inventory))

(defun game-eval (sexp)
  (if (member (car sexp) *allowed-commands*)
      (eval sexp)
      '(i do not know that command.)))

;game-print �Լ� �ۼ��ϱ�
(defun tweak-text (lst caps lit)
  (when lst
    (let ((item (car lst))
	  (rest (cdr lst)))
      (cond ((eql item #\space) (cons item (tweak-text rest caps lit)))
	    ((member item '(#\! #\? #\.)) (cons item (tweak-text rest t lit)))
	    ((eql item #\") (tweak-text rest caps (not lit)))
	    (lit (cons item (tweak-text rest nil lit)))
	    (caps (cons (char-upcase item) (tweak-text rest nil lit)))
	    (t (cons (char-downcase item) (tweak-text rest nil nil)))))))

(defun game-print (lst)
  (princ (coerce (tweak-text (coerce (string-trim "() "
						  (prin1-to-string lst))
				     'list)
			     t
			     nil)
		 'string))
  (fresh-line))

;REPL ����
;(game-repl)


;�������� ���� ������ ���� ����� ��ɾ� �����

;�� ���� ��ɾ� ���� �����

;���� ��ɾ�
(defun have (object)
  (member object (cdr (inventory))))

(defparameter *chain-welded* nil)

(defun weld (subject object)
  (if (and (eq *location* 'attic)
	   (eq subject 'chain)
	   (eq object 'bucket)
	   (have 'chain)
	   (have 'bucket)
	   (not *chain-welded*))
      (progn (setf *chain-welded* t)
	     '(the chain is now securely welded to the bucket.))
      '(you cannot seld like that.)))

(pushnew 'weld *allowed-commands*)


;�絿�̷� �칰�� ���� ��� ��ɾ�
(defparameter *bucket-filled* nil)

(defun dunk (subject object)
  (if (and (eq *location* 'garden)
	   (eq subject 'bucket)
	   (eq object 'well)
	   (have 'bucket)
	   *chain-welded*)
      (progn (setf *bucket-filled* 't)
	     '(the bucket is now full of water))
      '(you cannot duck like that.)))

(pushnew 'dunk *allowed-commands*)


;game-action ��ũ��
(defmacro game-action (command subj obj place &body obdy)
  `(progn (defun ,command (subject object)
	    (if (and (eq *location* ',place)
		     (eq subject ',subj)
		     (eq object ',obj)
		     (hav ',subj))
		,@body
		'(i cant ,command like that.)))
	  (pushnew ',command *allowed-commands*)))
