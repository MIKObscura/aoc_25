program day5
    use iso_fortran_env, only: int64
    implicit none
    character(len=100) :: line
    integer(kind=int64) :: ios, a, b, i, total_fresh
    integer(kind=int64), allocatable :: fresh_batches(:)
    integer(kind=int64), allocatable :: ingredients(:)
    integer(kind=int64) :: n_singles

    allocate(fresh_batches(0))
    n_singles = 0
    total_fresh = 0

    open(unit=10, file="input.txt", status="old", action="read")

    do
        read(10, '(A)', iostat=ios) line
        if (ios /= 0) exit

        if (scan(line, "-") == 0 .and. len_trim(line) > 0) then
            n_singles = n_singles + 1
        end if
    end do
    close(10)

    allocate(ingredients(n_singles))

    open(unit=10, file="input.txt", status="old", action="read")

    i = 0
    do
        read(10, '(A)', iostat=ios) line
        if (ios /= 0) exit

        if (scan(line, "-") > 0) then
            read(line(1:scan(line,"-")-1), *) a
            read(line(scan(line,"-")+1:), *) b
            call append_range(fresh_batches, a, b)
        else if (len_trim(line) > 0) then
            i = i + 1
            read(line, *) ingredients(i)
        end if
    end do
    close(10)

    do i = 1, size(ingredients)
        if (ingredient_is_fresh(ingredients(i), fresh_batches)) total_fresh = total_fresh + 1
    end do
    print *, total_fresh

contains

    subroutine append_range(arr, a, b)
        integer(kind=int64), allocatable, intent(inout) :: arr(:)
        integer(kind=int64), intent(in) :: a, b
        integer(kind=int64), allocatable :: tmp(:)
        integer(kind=int64) :: old_size, new_size

        old_size = size(arr)
        new_size = old_size + 2

        allocate(tmp(new_size))

        if (old_size > 0) tmp(1:old_size) = arr

        tmp(old_size + 1) = a
        tmp(old_size + 2) = b

        call move_alloc(tmp, arr)
    end subroutine append_range

    function ingredient_is_fresh(ingredient, fresh_batches) result(res)
        integer(kind=int64) :: ingredient,i
        integer(kind=int64) :: fresh_batches(:)
        logical :: res

        res = .FALSE.

        do i = 1, size(fresh_batches) - 1, 2
            if (ingredient >= fresh_batches(i) .AND. ingredient <= fresh_batches(i + 1)) then
                res = .TRUE.
            end if
        end do
    end function

end program day5
