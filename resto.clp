; =================================================================================
;                                   TEMPLATES
; =================================================================================

; Defining template for restaurants
(deftemplate restaurant 
    (slot name)
    (slot isSmoker)
    (multislot rangeBudget)
    (multislot dresscode)
    (slot hasWifi)
    (slot latitude)
    (slot longitude)
    (slot processed)
)

; Defining template for user
(deftemplate user
    (slot name)
    (slot smoke) 
    (slot minBudget)
    (slot maxBudget) 
    (slot clothes)
    (slot wantWifi)
    (slot latitude)
    (slot longitude)
)

(deftemplate result
    (slot name)
    (slot score)
    (slot rank)
)

(deftemplate counter (slot no))

; =================================================================================
;                                   FACTS
; =================================================================================

; Defining initial facts
(deffacts initial-facts "registered restaurant and user"
    (restaurant (name Restoran-A) (isSmoker TRUE) (rangeBudget 1000 2000) (dresscode casual) (hasWifi yes) (latitude -6.8922186) (longitude 107.5886173))
    (restaurant (name Restoran-B) (isSmoker FALSE) (rangeBudget 1200 2500) (dresscode informal) (hasWifi yes) (latitude -6.224085) (longitude 106.7859815))
    (restaurant (name Restoran-C) (isSmoker TRUE) (rangeBudget 2000 4000) (dresscode formal) (hasWifi no) (latitude -6.2145285) (longitude 106.8642591))
    (restaurant (name Restoran-D) (isSmoker FALSE) (rangeBudget 500 1400) (dresscode formal) (hasWifi no) (latitude -6.9005363) (longitude 107.6222191))
    (restaurant (name Restoran-E) (isSmoker TRUE) (rangeBudget 1000 2000) (dresscode informal casual) (hasWifi yes) (latitude -6.2055617) (longitude 106.8001597))
    (restaurant (name Restoran-F) (isSmoker FALSE) (rangeBudget 2500 5000) (dresscode informal) (hasWifi yes) (latitude -6.9045679) (longitude 107.6399745))
    (restaurant (name Restoran-G) (isSmoker TRUE) (rangeBudget 1300 3000) (dresscode casual) (hasWifi yes) (latitude -6.1881082) (longitude 106.7844409))
    (restaurant (name Restoran-H) (isSmoker FALSE) (rangeBudget 400 1000) (dresscode informal) (hasWifi no) (latitude -6.9525133) (longitude 107.6052906))
    (restaurant (name Restoran-I) (isSmoker FALSE) (rangeBudget 750 2200) (dresscode informal casual) (hasWifi yes) (latitude -6.9586985) (longitude 107.7092281))
    (restaurant (name Restoran-J) (isSmoker FALSE) (rangeBudget 1500 2000) (dresscode casual) (hasWifi yes) (latitude -6.2769732) (longitude 106.775133))
    (counter (no 0))
)


; =================================================================================
;                                   HELPER FUNCTION
; =================================================================================

; Function for validating answer 
(deffunction ask-question (?question $?allowed-values)
    (printout t ?question)
    (bind ?answer (read))
    (if (lexemep ?answer) then 
        (bind ?answer (lowcase ?answer))
    )
    (while (not (member ?answer ?allowed-values)) do
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
    (while (not (numberp ?answer)) do 
        (printout t "Wrong number! " ?question)
        (bind ?answer (read))
    )
    (while (or (< ?answer ?min) (> ?answer ?max))
        (printout t "Number must be in range! " ?question)
        (bind ?answer (read))
        (while (not (numberp ?answer)) do 
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
    (while (not (numberp ?answer)) do 
        (printout t "Wrong number! " ?question)
        (bind ?answer (read))
    )
    ?answer
)

; =================================================================================
;                                   MAIN PROGRAM
; =================================================================================

(defrule prepare-answer 
    ?r <- (restaurant (name ?rname))
    ?f <- (counter (no ?rank))
    (not (result (name ?rname)))
    =>
    (bind ?rank (+ ?rank 1))
    (assert (result (name ?rname) (score 0) (rank ?rank)))
    (modify ?f (no ?rank))
    (modify ?r (processed yes))
)

; Asking question to user
(defrule ask-questions
    =>

    (printout t "What is your name? ")
    (bind ?uname (read))

    (bind ?usmoke (ask-question "Do you smoke? (yes, no) " yes no))

    (bind ?uminBudget (ask-range-question "What is your minimum budget? [0-9999] " 0 9999))

    (bind ?umaxBudget (ask-range-question "What is your maximum budget? [0-9999] " 0 9999))

    (bind ?uclothes (ask-question "What clothes are you wearing? (casual, informal, formal) " casual informal formal))

    (bind ?uwantWifi (ask-question  "Do you want a restaurant with Wi-Fi? (yes, no) " yes no))

    (bind ?ulatitude (ask-number-question "What are your lat. coordinate? "))

    (bind ?ulongitude (ask-number-question "What are your long. coordinate? "))

    (assert (user (name ?uname) (smoke ?usmoke) (minBudget ?uminBudget) (maxBudget ?umaxBudget) (clothes ?uclothes) (wantWifi ?uwantWifi) (latitude ?ulatitude) (longitude ?ulongitude)))
    (printout t crlf crlf "Hai " ?uname ", here's our recommendation:" crlf)
)

(defrule find-solution-smoke
    (user (smoke ?iAmSmoker))
    ?resto <- (restaurant (name ?rname) (isSmoker ?restoForSmoker))
    ?res <- (result (name ?rname) (score ?rscore))
    (not (and (eq ?iAmSmoker yes) (eq ?restoForSmoker TRUE))) ; asumsi non smoker mau ke smoking resto ...
    (not (eval-smoke ?rname))
    =>
    (printout t ?rname " got smoke point " crlf)
    (modify ?res (score (+ ?rscore 1)))
    (assert (eval-smoke ?rname))
)

(defrule find-solution-wifi
    (user (wantWifi ?uwantWifi))
    ?resto <- (restaurant (name ?rname) (hasWifi ?restoHaveWifi))
    ?res <- (result (name ?rname) (score ?rscore))
    (not (and (eq ?uwantWifi yes) (eq ?restoHaveWifi yes)))
    (not (eval-wifi ?rname))
    =>
    (printout t ?rname " got wifi point " crlf)
    (modify ?res (score (+ ?rscore 1)))
    (assert (eval-wifi ?rname))
)

(defrule find-solution-clothes
    (user (clothes ?uclothes))
    ?resto <- (restaurant (name ?rname) (dresscode $? ?uclothes $?))
    ?r <- (result (name ?rname) (score ?rscore))
    (not (eval-clothes ?rname))
    =>
    (printout t ?rname " got dresscode point " crlf)
    (modify ?r (score (+ ?rscore 1)))
    (assert (eval-clothes ?rname))
)