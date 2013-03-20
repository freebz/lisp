;운명의 주사위 게임 버전 1 구현하기

;전역변수 선언하기
(defparameter *num-players* 2)
(defparameter *max-dice* 3)
(defparameter *board-size* 2)
(defparameter *board-hexnum* (* *board-size* *board-size*))

;게임판 구현하기
(defun board-array (lst)
  (make-array *board-hexnum* :initial-contents lst))

(defun gen-board ()
  (board-array (loop for n below *board-hexnum*
		    collect (list (random *num-players*)
				  (1+ (random *max-dice*))))))

(defun player-letter (n)
  (code-char (+ 97 n)))

(defun draw-board (board)
  (loop for y below *board-size*
       do (progn (fresh-line)
		 (loop repeat (- *board-size* y)
		      do (princ "  "))
		 (loop for x below *board-size*
		      for hex = (aref board (+ x (* *board-size* y)))
		      do (format t "~a-~a " (player-letter (first hex))
				 (second hex))))))

;운명의 주사위 게임 규칙 분리하기
;게임 트리 생성하기
(defun game-tree (board player spare-dice first-move)
  (list player
	board
	(add-passing-move board
			  player
			  spare-dice
			  first-move
			  (attacking-moves board player spare-dice))))

;차례 넘기기
(defun add-passing-move (board player spare-dice first-move moves)
  (if first-move
      moves
      (cons (list nil
		  (game-tree (add-new-dice board player (1- spare-dice))
			     (mod (1+ player) *num-players*)
			     0
			     t))
	    moves)))

;공격 이동 계산하기
(defun attacking-moves (board cur-player spare-dice)
  (labels ((player (pos)
	     (car (aref board pos)))
	   (dice (pos)
	     (cadr (aref board pos))))
    (mapcan (lambda (src)
	      (when (eq (player src) cur-player)
		(mapcan (lambda (dst)
			  (when (and (not (eq (player dst) cur-player))
				     (> (dice src) (dice dst)))
			    (list
			     (list (list src dst)
				   (game-tree (board-attack board cur-player src dst (dice src))
					      cur-player
					      (+ spare-dice (dice dst))
					      nil)))))
			(neighbors src))))
	    (loop for n below *board-hexnum*
		 collect n))))

;인접 영역 찾기
(defun neighbors (pos)
  (let ((up (- pos *board-size*))
	(down (+ pos *board-size*)))
    (loop for p in (append (list up down)
			   (unless (zerop (mod pos *board-size*))
			     (list (1- up) (1- pos)))
			   (unless (zerop (mod (1+ pos) *board-size*))
			     (list (1+ pos) (1+ down))))
	 when (and (>= p 0) (< p *board-hexnum*))
	 collect p)))

;공격
(defun board-attack (board player src dst dice)
  (board-array (loop for pos from 0
		  for hex across board
		  collect (cond ((eq pos src) (list player 1))
				((eq pos dst) (list player (1- dice)))
				(t hex)))))

;병력 충원하기
(defun add-new-dice (board player spare-dice)
  (labels ((f (lst n)
	     (cond ((null lst) nil)
		   ((zerop n) lst)
		   (t (let ((cur-player (caar lst))
			    (cur-dice (cadar lst)))
			(if (and (eq cur-player player) (< cur-dice *max-dice*))
			    (cons (list cur-player (1+ cur-dice))
				  (f (cdr lst) (1- n)))
			    (cons (car lst) (f (cdr lst) n))))))))
    (board-array (f (coerce board 'list) spare-dice))))

;새로운 game-tree 함수 사용하기
