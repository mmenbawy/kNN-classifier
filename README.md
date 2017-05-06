# kNN-classifier
student grade prediction

Given a generic distance function, a number k, a list old of Ex objects, and a list new of NewSt objects,
returns the predictions for every element in new using the k-neighborhood from the list old. The result
should be a list of tuples, containing the name and label of each element.

>>>classify_all euclidean 3 [(Ex 9 9 "john" "pass"),(Ex 9.5 8.5 "Tom" "pass"),(Ex 8 9.5 "lily" "pass"),(Ex 7 10 "ben" "pass"),(Ex 4 3 "sam" "fail"),(Ex 1 1.2 "stone" "fail"),(Ex 6.5 8 "andy" "fail")] [(NewSt 7.5 8 "Leo"),(NewSt 2.5 3 "Sherry"),(NewSt 5 5 "Kubo")]

>>>[("Leo","pass"),("Sherry","fail"),("Kubo","fail")]

