import Data.List

data Ex = Ex Float Float String String deriving Show
data NewSt = NewSt Float Float String deriving Show
data Dist = Dist Float NewSt Ex deriving Show

euclidean :: NewSt -> Ex -> Dist
euclidean (NewSt mid quiz name) (Ex midX quizX nameX grade) = 
    Dist (sqrt  ((( midX-mid )^2) + (( quizX-quiz )^2)) )  (NewSt mid quiz name) (Ex midX quizX nameX grade)

manhattan :: NewSt -> Ex -> Dist
manhattan (NewSt mid quiz nameC) (Ex midx quizx name grade) = 
				Dist ((abs (quizx - quiz))+ (abs (midx - mid))) (NewSt mid quiz nameC) (Ex midx quizx name grade) 
-- calculate the manhattan distance between the new student and the ex-student using the formula distance = (y2-y1)+(x2-x1)

dist :: (a -> b -> c) -> a -> b -> c
dist f a b = f a b
-- dist take a function f and two points(new student or ex student) and calls the function f on them.

all_dists :: (a -> b -> c) -> a -> [b] -> [c]
all_dists f new [] = []
all_dists f new (x:xs) = dist f new x : all_dists f new xs  

takeN :: Num a => a -> [b] -> [b]
takeN n [] = []
takeN n (x:xs) 
		| n == 0 = []
		| otherwise = x : (takeN (n-1) xs)
-- outputs a list containing the first element of the input list and decrements the number n
-- when n reaches zero the output list becomes is complete with the first n elements of the input list
-- if the input list is empty before the value of n reaches zero then the output list is complete too with its existing elements 

insert1 x []= [x]
insert1 (Dist n x y) ((Dist n1 x1 y1):xs) | n < n1 = (Dist n x y):(Dist n1 x1 y1):xs | otherwise = (Dist n1 x1 y1):insert1 (Dist n x y) xs
-- inserting dist in the right ascending order in a list of dists.

sort1 [] = [] 
sort1 ((Dist n x y):xs) = insert1 (Dist n x y) (sort1 xs)
-- sorting the list of dist using the insert1 function.

closest :: Num a => (b -> c -> Dist) -> a -> [c] -> b -> [Dist]
closest  f n ex st = takeN n (sort1((all_dists f st ex)))
-- it returns the closest n ex-students to the student by calling takeN on the list of the ascendingly sorted dists between
-- the new students and every ex students in ex list.

grouped_dists :: Num a => (b -> c -> Dist) -> a -> [c] -> b -> [[Dist]]
grade_label (Dist dist new (Ex mid quiz name grade)) (Dist dist2 new2 (Ex mid2 quiz2 name2 grade2))
		= grade == grade2 
grouped_dists f n exs new = groupBy (grade_label) (closest f n exs new)

mode :: Num a => (b -> c -> Dist) -> a -> [c] -> b -> [Dist]
mode f n (x:xs) y = helper_mode (grouped_dists f n (x:xs) y)
-- calls the helper function helper_mode with the list of lists produced from grouped_dists

helper_mode [] = []
helper_mode (x:xs) 
		| length x == maximum (map length (x:xs)) = x
		| otherwise = helper_mode xs
-- calculate the lengths of all lists in the input list of lists then calculate the maximum length of them
-- compare this maximum length with each the length of each list in the list of lists untill finding a match 
-- and outputting the list having the match

label_of :: [Dist] -> ([Char],[Char])
label_of ((Dist n (NewSt mid quiz name) (Ex midX quizX nameX grade)):xs) = (name,grade) 
-- takes as an input a list of Dist data and output a tuple/pair containing the name of the NewSt in the first Dist element 
-- in the input list and the grade of the Ex student in the first Dist element in the input list

classify :: Num a => (b -> c -> Dist) -> a -> [c] -> b -> ([Char],[Char])
classify f k exs new = label_of (mode f k exs new)
 
classify_all :: (a -> b -> Dist) -> Int -> [b] -> [a] -> [([Char],[Char])]
classify_all f k exs [] = []
classify_all f k exs (x:xs) = classify f k exs x : classify_all f k exs xs
-- takes a distance function, a number k, a list old of Ex objects, and a list new of NewSt objects as inputs
-- the function calls the classify function on each element of the NewSt list producing a list of tuples/pairs 
-- having the name and predicted grade of each NewSt in the list

