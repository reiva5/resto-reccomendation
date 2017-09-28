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