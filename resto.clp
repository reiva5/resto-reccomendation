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
    (printout t "[Type 'nehi' (without quotes) if you don't want to state]" crlf)
    (bind ?uname (ask-name "What is your name? "))

    (bind ?usmoke (ask-question "Do you smoke? (yes, no) " yes no))

    (bind ?uminBudget (ask-range-question "What is your minimum budget? [0-9999] " 0 9999))

    (bind ?umaxBudget (ask-range-question "What is your maximum budget? [0-9999] " 0 9999))

    (bind ?uclothes (ask-question "What clothes are you wearing? (casual, informal, formal) " casual informal formal))

    (bind ?uwantWifi (ask-question  "Do you want a restaurant with Wi-Fi? (yes, no) " yes no))

    (bind ?ulatitude (ask-number-question "What are your lat. coordinate? "))

    (bind ?ulongitude (ask-number-question "What are your long. coordinate? "))

    (assert (user (name ?uname) (smoke ?usmoke) (minBudget ?uminBudget) (maxBudget ?umaxBudget) (clothes ?uclothes) (wantWifi ?uwantWifi) (latitude ?ulatitude) (longitude ?ulongitude)))
    (printout t crlf crlf "Hai " ?uname ", here's our recommendation:" crlf)
    (assert (print-sorted))
)

(defrule validate-min-budget "If min budget is 'nehi', set to minimum."
  ?us <- (user (minBudget ?minBudget))
  (test (eq ?minBudget nehi))
  =>
  (modify ?us (minBudget 0))
)

(defrule validate-max-budget "If min budget is 'nehi', set to maximum."
  ?us <- (user (maxBudget ?maxBudget))
  (test (eq ?maxBudget nehi))
  =>
  (modify ?us (maxBudget 9999))
)

(defrule validate-lat-long "If lat exclusive-or long is 'nehi', set both nehi."
  ?us <- (user (latitude ?latitude) (longitude ?longitude))
  (test (or (eq ?latitude nehi) (eq ?longitude nehi)))
  (test (neq ?latitude ?longitude))
  =>
  (printout t "Either latitude or longitude is 'nehi'. Ignoring both value..." crlf)
  (modify ?us (latitude nehi) (longitude nehi))
)

(defrule calculate-distance-squared "Calculate distance from user to each restaurants."
  (user (latitude ?userLatitude) (longitude ?userLongitude))
  (test (and (neq ?userLatitude nehi) (neq ?userLongitude nehi)))
  (restaurant (name ?restaurantName) (latitude ?restaurantLatitude) (longitude ?restaurantLongitude))
  (not (distance ?restaurantName ?distance))
  =>
  (bind ?latDist (- ?userLatitude ?restaurantLatitude))
  (bind ?latDistSquare (* ?latDist ?latDist))
  (bind ?longDist (- ?userLongitude ?restaurantLongitude))
  (bind ?longDistSquare (* ?longDist ?longDist))
  (assert (distance ?restaurantName (sqrt (+ ?latDistSquare ?longDistSquare))))
)

(defrule find-solution-smoke
    (user (smoke ?iAmSmoker))
    (test (neq ?iAmSmoker nehi))
    ?resto <- (restaurant (name ?rname) (isSmoker ?restoForSmoker))
    ?res <- (result (name ?rname) (score ?rscore))
    (not (and (eq ?iAmSmoker yes) (eq ?restoForSmoker TRUE))) ; asumsi non smoker mau ke smoking resto ...
    (not (eval-smoke ?rname))
    =>
    (modify ?res (score (+ ?rscore 1)))
    (assert (eval-smoke ?rname))
)

(defrule find-solution-wifi
    (user (wantWifi ?uwantWifi))
    (test (neq ?uwantWifi nehi))
    ?resto <- (restaurant (name ?rname) (hasWifi ?restoHaveWifi))
    ?res <- (result (name ?rname) (score ?rscore))
    (not (and (eq ?uwantWifi yes) (eq ?restoHaveWifi yes)))
    (not (eval-wifi ?rname))
    =>
    (modify ?res (score (+ ?rscore 1)))
    (assert (eval-wifi ?rname))
)

(defrule find-solution-clothes
    (user (clothes ?uclothes))
    (test (neq ?uclothes nehi))
    ?resto <- (restaurant (name ?rname) (dresscode $? ?uclothes $?))
    ?r <- (result (name ?rname) (score ?rscore))
    (not (eval-clothes ?rname))
    =>
    (modify ?r (score (+ ?rscore 1)))
    (assert (eval-clothes ?rname))
)

(defrule find-solution-budget
    (user (minBudget ?min) (maxBudget ?max))
    (test (and (neq ?min nehi) (neq ?max nehi)))
    (restaurant (name ?rname) (rangeBudget ?rmin ?rmax))
    (test (and (<= ?max ?rmax) (>= ?min ?rmin)))
    ?r <- (result (name ?rname) (score ?rscore))
    (not (eval-budget ?rname))
    =>
    (modify ?r (score (+ ?rscore 1)))
    (assert (eval-budget ?rname))
)

(defrule assert-unprinted "Asserts each item that needs to be printed."
    (declare (salience -10))
    (print-sorted)
    (result (name ?n))
    =>
    (assert (unprinted ?n))
)

(defrule retract-print-sorted "Retract print-sorted after all items enumerated."
    (declare (salience -100))
    ?f <- (print-sorted)
    =>
    (retract ?f)
)

(defrule sort-rank-score "Sort the rank based on score."
  ?resA <- (result (name ?nameA) (score ?scoreA) (rank ?rankA))
  ?resB <- (result (name ?nameB) (score ?scoreB) (rank ?rankB))
  (test (> ?scoreA ?scoreB))
  (test (> ?rankA ?rankB))
  =>
  (modify ?resA (rank ?rankB))
  (modify ?resB (rank ?rankA))
)

(defrule sort-rank-distance "Sort the rank based on distance."
  (user (latitude ?latitude))
  (test (neq ?latitude nehi))
  ?resA <- (result (name ?nameA) (score ?scoreA) (rank ?rankA))
  ?resB <- (result (name ?resB) (score ?scoreB) (rank ?rankB))
  (distance ?nameA ?distanceA)
  (distance ?nameB ?distanceB)
  (test (eq ?scoreA ?scoreB))
  (test (< ?distanceA ?distanceB))
  (test (> ?rankA ?rankB))
  =>
  (modify ?resA (rank ?rankB))
  (modify ?resB (rank ?rankA))
)

(defrule print-all "Prints the unprinted item with the greatest smallest rank."
    (not (print-sorted))
    ?u <- (unprinted ?name)
    (result (name ?name) (score ?score) (rank ?rank))
    (forall (and
                (and
                  (unprinted ?n)
                  (result (name ?n) (rank ?r))
                )
                (test (not (eq ?n ?name)))
            )
        (test (> ?r ?rank))
    )
  =>
  (retract ?u)
  (printout t "> " ?name " has score " ?score " and rank " ?rank "." crlf)
)
