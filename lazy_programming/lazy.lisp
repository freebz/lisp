;지연 프로그래밍

;리스프에 지연 평가 추가하기

;lazy와 force 명령 만들기

(defmacro lazy (&body body)
  (let ((forced (gensym))
	(value (gensym)))
    `(let ((,forced nil)
	   (,value nil))
       (lambda ()
	 (unless ,forced
	   (setf ,value (progn ,@body))
	   (setf ,forced t))
	 ,value))))

(defun force (lazy-value)
  (funcall lazy-value))


;지연 리스트 라이브러리 만들기
(defmacro lazy-cons (a d)
  `(lazy (cons ,a ,d)))

(defun lazy-car (x)
  (car (force x)))

(defun lazy-cdr (x)
  (cdr (force x)))

(defparameter *integers*
  (labels ((f (n)
	     (lazy-cons n (f (1+ n)))))
    (f 1)))

(defun lazy-nil ()
  (lazy nil))

(defun lazy-null (x)
  (not (force x)))


;일반 리스트와 지연 리스트 사이의 변환
(defun make-lazy (lst)
  (lazy (when lst
	  (cons (car lst) (make-lazy (cdr lst))))))

(defun take (n lst)
  (unless (or (zerop n) (lazy-null lst))
    (cons (lazy-car lst) (take (1- n) (lazy-cdr lst)))))

(defun take-all (lst)
  (unless (lazy-null lst)
    (cons (lazy-car lst) (take-all (lazy-cdr lst)))))


;지연 리스트에 대해 매핑하고 검색하기
(defun lazy-mapcar (fun lst)
  (lazy (unless (lazy-null lst)
	  (cons (funcall fun (lazy-car lst))
		(lazy-mapcar fun (lazy-cdr lst))))))

(defun lazy-mapcan (fun lst)
  (labels ((f (lst-cur)
	     (if (lazy-null lst-cur)
		 (force (lazy-mapcan fun (lazy-cdr lst)))
		 (cons (lazy-car lst-cur) (lazy (f (lazy-cdr lst-cur)))))))
    (lazy (unless (lazy-null lst)
	    (f (funcall fun (lazy-car lst)))))))

(defun lazy-find-if (fun lst)
  (unless (lazy-null lst)
    (let ((x (lazy-car lst)))
      (if (funcall fun x)
	  x
	  (lazy-find-if fun (lazy-cdr lst))))))

(defun lazy-nth (n lst)
  (if (zerop n)
      (lazy-car lst)
      (lazy-nth (1- n)(lazy-cdr lst))))
