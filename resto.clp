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


