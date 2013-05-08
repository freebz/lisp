(def *small* 1)
(def *big* 100)

;guess-my-number �Լ� �����ϱ�
(defn guess-my-number []
  (bit-shift-right (+ *small* *big*) 1))

;smaller�� bigger �Լ� �����ϱ�
(defn smaller []
  (def *big* (dec (guess-my-number)))
  (guess-my-number))

(defn bigger []
  (def *small* (inc (guess-my-number)))
  (guess-my-number))

;start-over �Լ� �����ϱ�
(defn start-over []
  (def *small* 1)
  (def *big* 100)
  (guess-my-number))
