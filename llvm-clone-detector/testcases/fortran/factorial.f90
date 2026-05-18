! Test Case 2: Factorial — Fortran implementation
MODULE factorial_mod
  IMPLICIT NONE
CONTAINS

  FUNCTION factorial(n) RESULT(res)
    INTEGER, INTENT(IN) :: n
    INTEGER(KIND=8) :: res
    INTEGER :: i
    res = 1
    DO i = 2, n
      res = res * i
    END DO
  END FUNCTION factorial

  FUNCTION factorial_recursive(n) RESULT(res)
    INTEGER, INTENT(IN) :: n
    INTEGER(KIND=8) :: res
    IF (n <= 1) THEN
      res = 1
    ELSE
      res = n * factorial_recursive(n - 1)
    END IF
  END FUNCTION factorial_recursive

END MODULE factorial_mod

PROGRAM main
  USE factorial_mod
  IMPLICIT NONE
  INTEGER :: i
  DO i = 0, 10
    WRITE(*,*) i, '! =', factorial(i)
  END DO
END PROGRAM main
