(defparameter *small* 1)
(defparameter *big* 100)

;guess-my-number 함수 정의하기
(defun guess-my-number ()
  (ash (+ *small* *big*) -1))

;smaller와 bigger 함수 정의하기
(defun smaller ()
  (setf *big* (1- (guess-my-number)))
  (guess-my-number))

(defun bigger ()
  (setf *small* (1+ (guess-my-number)))
  (guess-my-number))

;start-over 함수 정의하기
(defun start-over ()
  (defparameter *small* 1)
  (defparameter *big* 100)
  (guess-my-number))