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
;(game-tree #((0 1)(1 1)(0 2)(1 1)) 0 0 t)

;다른 사람과 맞붙기

;주 반복문
(defun play-vs-human (tree)
  (print-info tree)
  (if (caddr tree)
      (play-vs-human (handle-human tree))
      (announce-winner (cadr tree))))

;게임의 상태 정보
(defun print-info (tree)
  (fresh-line)
  (format t "current player = ~a" (player-letter (car tree)))
  (draw-board (cadr tree)))

;사람의 입력값 처리하기
(defun handle-human (tree)
  (fresh-line)
  (princ "choose your move:")
  (let ((moves (caddr tree)))
    (loop for move in moves
	 for n from 1
	 do (let ((action (car move)))
	      (fresh-line)
	      (format t "~a. " n)
	      (if action
		  (format t "~a -> ~a" (car action) (cadr action))
		  (princ "end turn"))))
    (fresh-line)
    (cadr (nth (1- (read)) moves))))

;승자 가리기
(defun winners (board)
  (let* ((tally (loop for hex across board
		     collect (car hex)))
	 (totals (mapcar (lambda (player)
			   (cons player (count player tally)))
			 (remove-duplicates tally)))
	 (best (apply #'max (mapcar #'cdr totals))))
    (mapcar #'car
	    (remove-if (lambda (x)
			 (not (eq (cdr x) best)))
		       totals))))

(defun announce-winner (board)
  (fresh-line)
  (let ((w (winners board)))
    (if (> (length w) 1)
	(format t "The game is a tie between ~a" (mapcar #'player-letter w))
	(format t "The winner is ~a" (player-letter (car w))))))

;지능을 갖춘 적 만들기

;미니맥스 알고리즘을 실제 코드로 구현하기
(defun rate-position (tree player)
  (let ((moves (caddr tree)))
    (if moves
	(apply (if (eq (car tree) player)
		   #'max
		   #'min)
	       (get-ratings tree player))
	(let ((w (winners (cadr tree))))
	  (if (member player w)
	      (/ 1 (length w))
	      0)))))

(defun get-ratings (tree player)
  (mapcar (lambda (move)
	    (rate-position (cadr move) player))
	  (caddr tree)))

;인공지능 플레이어와 함께 하는 게임 반복문 만들기
(defun handle-computer (tree)
  (let ((ratings (get-ratings tree (car tree))))
    (cadr (nth (position (apply #'max ratings) ratings) (caddr tree)))))

(defun play-vs-computer (tree)
  (print-info tree)
  (cond ((null (caddr tree)) (announce-winner (cadr tree)))
	((zerop (car tree)) (play-vs-computer (handle-human tree)))
	(t (play-vs-computer (handle-computer tree)))))

