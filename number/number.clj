(def *small* 1)
(def *big* 100)

;guess-my-number 함수 정의하기
(defn guess-my-number []
  (bit-shift-right (+ *small* *big*) 1))

;smaller와 bigger 함수 정의하기
(defn smaller []
  (def *big* (dec (guess-my-number)))
  (guess-my-number))

(defn bigger []
  (def *small* (inc (guess-my-number)))
  (guess-my-number))

;start-over 함수 정의하기
(defn start-over []
  (def *small* 1)
  (def *big* 100)
  (guess-my-number))
