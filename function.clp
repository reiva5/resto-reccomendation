; Function for validating name
(deffunction ask-name (?question)
  (printout t ?question)
  (bind ?answer (read))
  (while (eq ?answer nehi) do
      (printout t "Name cannot be empty. Please provide your name." crlf)
      (printout t ?question)
      (bind ?answer (read))
  )
  ?answer
)

; Function for validating answer
(deffunction ask-question (?question $?allowed-values)
    (printout t ?question)
    (bind ?answer (read))
    (if (lexemep ?answer) then
        (bind ?answer (lowcase ?answer))
    )
    (while (and (not (eq ?answer nehi)) (not (member ?answer ?allowed-values))) do
        (printout t "Wrong answer! " ?question)
        (bind ?answer (read))
        (if (lexemep ?answer) then
            (bind ?answer (lowcase ?answer))
        )
    )
    ?answer
)

; Function for converting distance into score
(deffunction convert-distance-to-score (?distance)
    (bind ?score (+(* (- ?distance 202) -1) 100))
    ?score
)

; Function for validating number in range
(deffunction ask-range-question (?question ?min ?max)
    (printout t ?question)
    (bind ?answer (read))
    (while (and (not (eq ?answer nehi)) (not (numberp ?answer))) do
        (printout t "Wrong number! " ?question)
        (bind ?answer (read))
    )
    (while (and (not (eq ?answer nehi)) (or (< ?answer ?min) (> ?answer ?max))) do
        (printout t "Number must be in range! " ?question)
        (bind ?answer (read))
        (while (and (not (eq ?answer nehi)) (not (numberp ?answer))) do
            (printout t "Wrong number! " ?question)
            (bind ?answer (read))
        )
    )
    ?answer
)

; Function for validating latitude answer
(deffunction ask-latitude (?question)
    (printout t ?question)
    (bind ?answer (read))
    (while (or (and (not (eq ?answer nehi)) (not (numberp ?answer))) (and (numberp ?answer) (or (< ?answer -90) (> ?answer 90)))) do
        (printout t "Wrong number! " ?question)
        (bind ?answer (read))
    )
    ?answer
)

; Function for validating latitude answer
(deffunction ask-longitude (?question)
    (printout t ?question)
    (bind ?answer (read))
    (while (or (not (numberp ?answer)) (or (< ?answer -180) (> ?answer 180))) do
        (printout t "Wrong number! " ?question)
        (bind ?answer (read))
    )
    
    ?answer
)