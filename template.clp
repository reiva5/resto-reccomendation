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