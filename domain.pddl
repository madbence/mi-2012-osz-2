;Adott egy folyó, amin komp kel át. A folyó egyik oldalán különböző járművek várnak az átkelésre: nagy tehergépkocsik, közepes méretű furgonok, és
;kisebb méretű személyképkocsik. A kompon véges sok fix parkolóhely van: 1 a nagy kocsik számára, 2 a furgonoknak, és 4 a személygépkocsiknak.
;A komp kezdetben ezen a parton áll lehajtott felhajtóval. Ahhoz, hogy a járművek felhajthassanak rá, a felhajtója le kell, hogy legyen hajtva. Ahhoz, hogy el
;tudjon indulni fel kell hajtania a felhajtóját. Aztán akár üresen, akár részben vagy egészben tele, átúszhat a másik partra. A másik parton, ahhoz hogy
;az egyes, rajta lévő járművek le tudjanak hajtani róla, le kell hajtania a felhajtóját. További komplikáció, hogy a nagy tehergépkocsikkal csak úgy tud
;elindulni, ha azok a kompon meg vannak erősítve. Az átkelés után nyilván le kell venni ezt a megerősítést a nagy tehergépkocsikról ahhoz, hogy le tudjanak
;hajtani a kompról (a lehajtott felhajtón). Készítsen tervet arra, hogy az ezen a parton várakozó járművek (legalább egy része) átkelhessen a túlsó partra!

(define	(domain komp)
(:requirements :strips :equality :typing)
(:types 		car van truck - vehicle)
(:constants		left right komp)
(:predicates	(on ?x ?y) ;rajta van valami valamin
				(fixed ?truck) ;meg van-e erositve
				(ready ?komp)) ;le van-e hajtva a lehajtoja a kompnak

;Szemelygepkocsi felszall, max 4
(:action up_car
:parameters 	(?car - car)
:precondition	(and
					(on ?car left)
					(on komp left)
					(ready komp)
					(not 
						(exists
							(?x ?y ?z ? ?w - car)
							(and	
								(not (= ?x ?car))
								(not (= ?y ?car))
								(not (= ?z ?car))
								(not (= ?w ?car))
								(not (= ?x ?y))
								(not (= ?x ?z))
								(not (= ?y ?z))
								(not (= ?x ?w))
								(not (= ?y ?w))
								(not (= ?z ?w))
								(on ?x komp)
								(on ?y komp)
								(on ?z komp)
								(on ?w komp)
							)
						)
					)
				)
:effect		(and
				(on ?car komp)
				(not (on ?car left))
			)
)

;Furgon felszall, max 2
(:action up_van
:parameters 	(?car - van)
:precondition	(and
					(on ?car left)
					(on komp left)
					(ready komp)
					(not 
						(exists
							(?x ?y - van)
							(and	
								(not (= ?x ?car))
								(not (= ?y ?car))
								(not (= ?x ?y))
								(on ?x komp)
								(on ?y komp)
							)
						)
					)
				)
:effect		(and
				(on ?car komp)
				(not (on ?car left))
			)
)

;Teherauto felszall, max 1
(:action up_truck
:parameters 	(?car - truck)
:precondition	(and
					(on ?car left)
					(on komp left)
					(ready komp)
					(not 
						(exists
							(?x - truck)
							(and	
								(not (= ?x ?car))
								(on ?x komp)
							)
						)
					)
				)
:effect		(and
				(on ?car komp)
				(not (on ?car left))
			)
)

;Szemelygepkocsi leszall
(:action down_car
:parameters		(?car - car)
:precondition	(and
					(on ?car komp)
					(on komp right)
					(ready komp))
:effect		(and
				(on ?car right)
				(not (on ?car komp))
			)
)

;Furgon leszall
(:action down_van
:parameters		(?car - van)
:precondition	(and
					(on ?car komp)
					(on komp right)
					(ready komp))
:effect		(and
				(on ?car right)
				(not (on ?car komp))
			)
)

;Teherauto leszall, ha nincs megkotve
(:action down_truck
:parameters		(?car - truck)
:precondition	(and
					(on ?car komp)
					(on komp right)
					(ready komp)
					(not (fixed ?car)))
:effect		(and
				(on ?car right)
				(not (on ?car komp))
			)
)

;atmegy a folyon, ha fel van hajtva a felhajto, es meg van kotve az esetleges teherauto
(:action travel
:parameters		(?start ?goal)
:precondition	(and
					(on komp ?start)
					(not (on komp ?goal))
					(not (ready komp))
					(forall
						(?x - truck)
						(or
							(fixed ?x)
							(not (on ?x komp))
						)
					)
				)
:effect			(and (on komp ?goal) (not (on komp ?start))))

;Teherautot megfog
(:action fix
:parameters		(?truck - truck)
:precondition	(and
					(on ?truck komp)
					(not (fixed ?truck))
				)
:effect		(fixed ?truck))

;Teherautot elenged
(:action unfix
:parameters		(?truck - truck)
:precondition	(and
					(on ?truck komp)
					(fixed ?truck)
				)
:effect		(not(fixed ?truck)))

;felhajto lenyit
(:action open
:precondition 	(not (ready komp))
:effect			(ready komp))

;felhajto felhajt
(:action close
:precondition 	(ready komp)
:effect			(not (ready komp))))