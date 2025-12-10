program day5
    use iso_fortran_env, only: int64
    implicit none
    character(len=100) :: line
    integer(kind=int64) :: ios, a, b, i, j, total_fresh, total_ranges
    integer(kind=int64), allocatable :: fresh_batches(:)
    integer(kind=int64), allocatable :: fresh_ranges(:, :), merged_ranges(:, :), tmp(:, :)
    integer(kind=int64), allocatable :: ingredients(:)
    integer(kind=int64) :: n_singles

    allocate(fresh_batches(0))
    n_singles = 0
    total_fresh = 0
    total_ranges = 1

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

    do i = 1, size(ingredients) ! Part 1
        if (ingredient_is_fresh(ingredients(i), fresh_batches)) total_fresh = total_fresh + 1
    end do
    print *, total_fresh

    call batches_to_pairs(fresh_batches, fresh_ranges) ! Part 2
    call sort_ranges(fresh_ranges, size(fresh_ranges, 2))
    allocate(merged_ranges(2, total_ranges))
    merged_ranges(:, 1) = fresh_ranges(:, 1)
    do i = 2, size(fresh_ranges, 2)
        if (intervals_overlap(merged_ranges(:, size(merged_ranges, 2)), fresh_ranges(:, i))) then
            merged_ranges(:, size(merged_ranges, 2)) = merge_intervals(merged_ranges(:, size(merged_ranges, 2)), fresh_ranges(:, i))
        else
            allocate(tmp(2, total_ranges + 1))
            tmp(:, 1:total_ranges) = merged_ranges(:, 1:total_ranges)
            total_ranges = total_ranges + 1
            tmp(:, total_ranges) = fresh_ranges(:, i)
            call move_alloc(tmp, merged_ranges)
        end if
    end do

    total_fresh = 0
    do i = 1, size(merged_ranges, 2)
        total_fresh = total_fresh + (merged_ranges(2, i) - merged_ranges(1, i)) + 1
    end do
    print *, total_fresh ! TODO: figure out why the answer isn't exactly right

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

    subroutine batches_to_pairs(batches, pairs)
        integer(kind=int64), allocatable, intent(in) :: batches(:)
        integer(kind=int64), allocatable, intent(inout) :: pairs(:, :)
        integer(kind=int64) :: i, j

        allocate(pairs(2, size(batches) / 2))
        j = 1
        do i = 1, size(batches), 2
            pairs(1, j) = batches(i)
            pairs(2, j) = batches(i + 1)
            j = j + 1
        end do

    end subroutine batches_to_pairs

    subroutine sort_ranges(ranges, n)
        integer, intent(in) :: n
        integer(kind=int64), intent(inout) :: ranges(2, n)
        integer(kind=int64) :: i, j
        real :: key1, key2

        do i = 2, n
            key1 = ranges(1, i)
            key2 = ranges(2, i)
            j = i - 1

            do while (j >= 1 .and. ranges(1, j) > key1)
                ranges(1, j+1) = ranges(1, j)
                ranges(2, j+1) = ranges(2, j)
                j = j - 1
            end do

            ranges(1, j+1) = key1
            ranges(2, j+1) = key2
        end do
    end subroutine sort_ranges

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

    function intervals_overlap(interval1, interval2) result(res)
        integer(kind=int64), dimension(2) :: interval1, interval2
        logical :: res

        res = .FALSE.
        if (interval1(2) >= interval2(1)) then
            res = .TRUE.
        end if
    end function

    function merge_intervals(interval1, interval2) result(res)
        integer(kind=int64), dimension(2) :: interval1, interval2, res

        res = [minval([interval1(1), interval2(1)]), maxval([interval1(2), interval2(2)])]
    end function

end program day5
