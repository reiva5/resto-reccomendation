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

; Function for validating numeric answer
(deffunction ask-number-question (?question)
    (printout t ?question)
    (bind ?answer (read))
    (while (and (not (eq ?answer nehi)) (not (numberp ?answer))) do
        (printout t "Wrong number! " ?question)
        (bind ?answer (read))
    )
    ?answer
)