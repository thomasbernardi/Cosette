#lang rosette 
 
(require "../cosette.rkt" "../sql.rkt" "../evaluator.rkt" "../syntax.rkt") 
 
(provide ros-instance)
 
(current-bitwidth #f)
 
(define-symbolic div_ (~> integer? integer? integer?))
 
(define t-info (table-info "t" (list "k0" "c1" "f1_a0" "f2_a0" "f0_c0" "f1_c0" "f0_c1" "f1_c2" "f2_c3")))
 
(define account-info (table-info "account" (list "acctno" "type" "balance")))
 
(define bonus-info (table-info "bonus" (list "ename" "job" "sal" "comm")))
 
(define dept-info (table-info "dept" (list "deptno" "name")))
 
(define emp-info (table-info "emp" (list "empno" "ename" "job" "mgr" "hiredate" "comm" "sal" "deptno" "slacker")))
 

(define (q1 tables) 
  (SELECT (VALS "s.deptno") 
  FROM (JOIN (AS (SELECT (VALS "dept.deptno" "dept.name") 
  FROM (NAMED (RENAME (list-ref tables 3) "dept")) 
  WHERE (EXISTS (AS (SELECT (VALS "emp.empno" "emp.ename" "emp.job" "emp.mgr" "emp.hiredate" "emp.sal" "emp.comm" "emp.deptno" "emp.slacker") 
  FROM (NAMED (RENAME (list-ref tables 4) "emp")) 
  WHERE (AND (BINOP "emp.deptno" = "dept.deptno") (BINOP "emp.sal" > 100))) ["anyname" (list "empno" "ename" "job" "mgr" "hiredate" "sal" "comm" "deptno" "slacker")]))) ["s" (list "deptno" "name")]) (NAMED (RENAME (list-ref tables 1) "account"))) 
  WHERE (BINOP "s.deptno" = "account.acctno")))

(define (q2 tables) 
  (SELECT (VALS "t.deptno") 
  FROM (JOIN (AS (SELECT (VALS "dept.deptno") 
  FROM (NAMED (RENAME (list-ref tables 3) "dept")) 
  WHERE (TRUE)) ["t" (list "deptno")]) (JOIN (AS (SELECT (VALS "t1.deptno") 
  FROM (AS (SELECT (VALS "emp.sal" "emp.deptno") 
  FROM (NAMED (RENAME (list-ref tables 4) "emp")) 
  WHERE (TRUE)) ["t0" (list "sal" "deptno")]) 
  WHERE (BINOP "t0.sal" > 100)) ["t2" (list "deptno9")]) (AS (SELECT (VALS "account.acctno") 
  FROM (NAMED (RENAME (list-ref tables 1) "account")) 
  WHERE (TRUE)) ["t3" (list "acctno")]))) 
  WHERE (AND (BINOP "t.deptno" = "t2.deptno9") (BINOP "t.deptno" = "t3.acctno"))))


(define ros-instance (list q1 q2 (list t-info account-info bonus-info dept-info emp-info))) 