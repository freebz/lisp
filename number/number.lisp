(defparameter *small* 1)
(defparameter *big* 100)

;guess-my-number �Լ� �����ϱ�
(defun guess-my-number ()
  (ash (+ *small* *big*) -1))

;smaller�� bigger �Լ� �����ϱ�
(defun smaller ()
  (setf *big* (1- (guess-my-number)))
  (guess-my-number))

(defun bigger ()
  (setf *small* (1+ (guess-my-number)))
  (guess-my-number))

;start-over �Լ� �����ϱ�
(defun start-over ()
  (defparameter *small* 1)
  (defparameter *big* 100)
  (guess-my-number))