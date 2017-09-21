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



; =================================================================================
;                                   FACTS
; =================================================================================

; Defining initial facts
(deffacts initial-facts "registered restaurant and user"
    (restaurant (name Restoran-A) (isSmoker true) (rangeBudget 1000 2000) (dresscode casual) (hasWifi true) (latitude -6.8922186) (longitude 107.5886173))
    (restaurant (name Restoran-B) (isSmoker false) (rangeBudget 1200 2500) (dresscode informal) (hasWifi true) (latitude -6.224085) (longitude 106.7859815))
    (restaurant (name Restoran-C) (isSmoker true) (rangeBudget 2000 4000) (dresscode formal) (hasWifi false) (latitude -6.2145285) (longitude 106.8642591))
    (restaurant (name Restoran-D) (isSmoker false) (rangeBudget 500 1400) (dresscode formal) (hasWifi false) (latitude -6.9005363) (longitude 107.6222191))
    (restaurant (name Restoran-E) (isSmoker true) (rangeBudget 1000 2000) (dresscode informal casual) (hasWifi true) (latitude -6.2055617) (longitude 106.8001597))
    (restaurant (name Restoran-F) (isSmoker false) (rangeBudget 2500 5000) (dresscode informal) (hasWifi true) (latitude -6.9045679) (longitude 107.6399745))
    (restaurant (name Restoran-G) (isSmoker true) (rangeBudget 1300 3000) (dresscode casual) (hasWifi true) (latitude -6.1881082) (longitude 106.7844409))
    (restaurant (name Restoran-H) (isSmoker false) (rangeBudget 400 1000) (dresscode informal) (hasWifi False) (latitude -6.9525133) (longitude 107.6052906))
    (restaurant (name Restoran-I) (isSmoker false) (rangeBudget 750 2200) (dresscode informal casual) (hasWifi True) (latitude -6.9586985) (longitude 107.7092281))
    (restaurant (name Restoran-J) (isSmoker false) (rangeBudget 1500 2000) (dresscode casual) (hasWifi True) (latitude -6.2769732) (longitude 106.775133))
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

(deffunction affordable-price (?min ?max $?rangeBudget)
    (return TRUE)
)



; =================================================================================
;                                   MAIN PROGRAM
; =================================================================================

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

)

(defrule find-solution 
    (user (name ?uname) (smoke ?usmoke) (minBudget ?uminBudget) (maxBudget ?umaxBudget) (clothes ?uclothes) (wantWifi ?uwantWifi) (latitude ?ulatitude) (longitude ?ulongitude))
    (restaurant (name ?rname) (isSmoker ?rsmoke) (rangeBudget $?range) (dresscode $?rdresscode) (hasWifi ?rwifi))
    =>
    (printout t " >> " ?rname crlf)
)