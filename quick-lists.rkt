#lang class/2
(provide empty)
; A Forest is one of 
; (new forest-cons% Tree Forest)
; (new forest-emt%)

;; A [List X] implements
;; - cons : X -> [List X]
;;   Cons given element on to this list.
;; - first : -> X
;;   Get the first element of this list (only defined on non-empty lists).
;; - rest : -> [List X]
;;   Get the rest of this (only defined on non-empty lists).
;; - list-ref : Natural -> X
;;   Get the ith element of this list (only defined for lists of i+1 or more
;;   elements).
;; - length : -> Natural
;;   Compute the number of elements in this list.
;; - accept : [ListVisitor X Y]
;;   Accept given visitor and visit this list's data.
;; - fold : [ListFold X Y]
;;   Accept given fold and process this list's data.


;A forest-cons is a (new forest-cons% Tree Forest)
;forest-cons implements [List X]
;interp: tree is the current tree in this list
;        forest is the rest of the trees
(define-class forest-cons%
  (fields tree forest)
  (define (cons x)
    (if (and (>= (this . num-trees) 2) 
             (= (this . first-tree-size)
                (this . forest . first-tree-size)))
        (new forest-cons% (new tree-branch% x (this . tree)
                                    (this . forest . tree))
             (this . forest . forest))
        (new forest-cons% (new tree-leaf% x) this)))
  ;first-tree-size: -> Natural
  ;returns the size of the first tree in this forest
  (define (first-tree-size)
    (this . tree . tree-size))
  ;num-trees: -> Natural
  ;returns the number of trees in the forest
  (define (num-trees)
    (add1 (this . forest . num-trees)))
  
  (define (first)
    (this . tree . x))
  
  (define (rest)
    (if (= (this . first-tree-size) 1)
        (this . forest)
        (new forest-cons% (this . tree . left)
             (new forest-cons% (this . tree . right)
                  (this . forest)))))
        
  (define (list-ref n)
    (cond
      [(= n 0) (this . first)]
      [(> (this . first-tree-size) n)
       (this . tree . tree-ref n)]
      [else (this . forest . list-ref (- n (this . tree . tree-size)))]))
  
  (define (length)
    (+ (this . tree . tree-size)
       (this . forest . length)))
  
  (define (accept v)
    (v . visit-cons (this . first) (this . rest)))
  
  (define (fold f)
    (f . fold-cons (this . first) (this . rest . fold f))))

;A forest-emt is a (new forest-emt)
(define-class forest-emt% 
   (define (cons x)
    (new forest-cons% (new tree-leaf% x) (new forest-emt%)))
  ;num-trees: -> Natural
  ;returns the number of trees in the forest
  (define (num-trees) 0)
  ;first-tree-size: -> Natural
  ;returns the size of the first tree in this forest
  (define (first-tree-size) 0)
  (define (first)
    (error 'forest-emt "method 'first' is undefined on empty lists"))
  (define (rest)
    (error 'forest-emt "method 'rest' is undefined on empty lists"))
  (define (list-ref n)
    (error 'forest-emt "method 'list-ref' is undefined on lists with 
                        length i + 1"))
  (define (length) 0)
  (define (accept v)
    (v . visit-mt))
  (define (fold f) (f . fold-mt)))

; A Tree is one of 
; (new tree-branch% x left right) 
; (new tree-leaf% x)
; and implements:
; 
; tree-ref: Natural -> X
; returns the value in the tree with the index n
;
; tree-size: -> Natural
; returns size of tree

; A tree-branch is a (new tree-branch X Tree Tree)
; tree-branch implements Tree
;interp: x is this tree's element.
;        left is the branch to the left of this entry in the tree
;        right "  "   "     "   "  right "   "      "  "  "    "

(define-class tree-branch%
  (fields x left right )
    
  (define (tree-ref n)
    (cond 
      [(= n 0) (this . x)]
      [(< n (/ (this . tree-size) 2))
       (this . left . tree-ref (- n 1))]
      [(>= n (/ (this . tree-size) 2))
       (this . right . tree-ref (sub1 (- n (this . left . tree-size))))]))
  
  (define (tree-size)
    (+ 1 
       (this . left . tree-size )
       (this . right . tree-size))))

;A tree-leaf is a (new tree-leaf% X)
;tree-leaf implements tree
(define-class tree-leaf%
  (fields x)
  (define (tree-ref n)
    (this . x))
  (define (tree-size) 1))
  
(define empty (new forest-emt%))

(define ls (empty . cons 'a . cons 'b . cons 'c . cons 'd . cons 'e))
(define test-leaf (new tree-leaf% 'a))
(define test-tree (new tree-branch% 'a (new tree-branch% 'b (new tree-leaf% 'c)
                                                             (new tree-leaf% 'd))
                                         (new tree-branch% 'e (new tree-leaf% 'f)
                                                            (new tree-leaf% 'g))))

(check-expect (test-tree . tree-size) 7)
(check-expect (test-tree . tree-ref 0) 'a)
(check-expect (test-tree . tree-ref 1) 'b)
(check-expect (test-tree . tree-ref 2) 'c)
(check-expect (test-tree . tree-ref 3) 'd)
(check-expect (test-tree . tree-ref 4) 'e)
(check-expect (test-tree . tree-ref 5) 'f)
(check-expect (test-tree . tree-ref 6) 'g)


                            
 
(check-expect (empty . length) 0)
(check-expect (ls . length) 5)
(check-expect (ls . first) 'e)
(check-expect (ls . rest . first) 'd)
(check-expect (ls . rest . rest . first) 'c)
(check-expect (ls . rest . rest . rest . first) 'b)
(check-expect (ls . rest . rest . rest . rest . first) 'a)
 
(check-expect (ls . list-ref 0) 'e)
(check-expect (ls . list-ref 1) 'd)
(check-expect (ls . list-ref 2) 'c)
(check-expect (ls . list-ref 3) 'b)
(check-expect (ls . list-ref 4) 'a)