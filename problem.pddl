(define (problem komp1)
(:domain komp)
(:objects a b c d - car e f - van g h - truck)
(:init
	(ready komp)
	(on komp left)
	(on a left)
	(on b left)
	(on c left)
	(on d left)
	(on e left)
	(on f left)
	(on g left)
	(on h left))
(:goal (and 
	(on a right)
	(on b right)
	(on c right)
	(on d right)
	(on e right)
	(on f right)
	(on g right)
	(on h right))
))
