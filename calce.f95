!
!   CIS*3190 Assignment #4
!
!      Name: e Calculator
!      Author: Jacob Wadsworth
!      Date of Last Revision: April 8, 2022
!      Summary: This program calculates e to n given decimal places
!

program calce

implicit none

! declare variables
integer :: n
integer :: ierror
character (len=20) :: filename
integer :: eList(0:10000)

! read in input
do 
    write (*,*) "How many digits would you like to calculate?"
    read(*, 100, iostat = ierror) n
    100 format(I5)
    if (ierror == 0 .and. n >= 0) then
        exit
    end if
end do

! get filename
filename = getOutFile()

! calculate e
call calculate_e(n, eList)

! save e to file
call keepe(eList, filename, n)


contains
    ! gets the name of the output file
    character (len=20) function getOutFile()
        implicit none
        character (len=20) :: fname
        logical :: fExist = .TRUE.

        ! loop until file is valid
        do while (fExist .eqv. .TRUE.)

            ! read file name from console
            write (*,*) "Please enter the output file name: "
            read (*,"(A)") fname
            inquire(file = fname, exist=fExist)

            ! if file already exists print error and try again
            if (fExist .eqv. .True.) then
                write (*,*) "Error: File already Exists"
            end if

        end do

        ! return valid file name
        getOutFile = fname

    end function getOutFile

    subroutine calculate_e(n, eList)
        implicit none

        ! Declare Variables
        integer, intent(inout) :: n
        integer, intent(inout) :: eList(0:10000)

        integer :: m
        real :: test
        integer :: carry
        integer :: temp
        integer :: coef(10000)
        integer :: i
        integer :: j

        m = 4;
        test = (n+1) * 2.30258509;

        ! calculate value of m
        do while (real(m) * (log(real(m)) - 1.0) + 0.5 * log(6.2831852 * real(m)) < test)
            m = m + 1
        end do

        ! set coef values to 1
        j = 2
        do while (j <= m)
            coef(j) = 1
            j = j + 1
        end do

        ! set first value to 2
        eList(0) = 2;

        ! calculate values and store them in eList
        i = 1
        do while (i <= n)
            carry = 0

            j = m
            do while (j >= 2)
                temp = coef(j) * 10 + carry;
                carry = temp / j;
                coef(j) = temp - carry * j;
                j = j - 1
            end do

            eList(i) = carry;

            i = i + 1
        end do

    end subroutine calculate_e

    subroutine keepe(eList, filename, n)

        ! Declare Variables
        integer, intent(in) :: eList(0:10000)
        integer, intent(in) :: n
        character (len=20), intent(in) :: filename

        integer :: i

        ! open file
        open(unit = 1, file = filename, action = "write")

        ! write "2." to file
        write(1,101,advance='no') eList(0)
        101 format(I1)
        write(1,102,advance='no') "."
        102 format(A1)

        ! write digits of e to file
        i = 1
        do while (i < n)
            write(1, 101,advance='no') eList(i)
            i = i + 1
        end do

        ! close file
        close (1, status = "keep")

    end subroutine keepe


end program calce

