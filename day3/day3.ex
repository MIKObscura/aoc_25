defmodule AOC do
  def largest_joltage(line) do
    chars = String.graphemes(line)
    digits = Enum.map(chars, &elem(Integer.parse(&1), 0))
    largest = largest_digit(line)
    largest_index = Enum.find_index(digits, fn x -> x == largest end)
    from_largest = Enum.slice(digits, (largest_index + 1)..-1//1)
    second_largest = largest_digit(Enum.join(from_largest))
    {n, _} = Integer.parse(Enum.join([largest, second_largest]))
    n_rev = largest_joltage_rev(line)
    cond do
      n < n_rev -> n_rev
      true -> n
    end
  end

  def largest_joltage_rev(line) do
    chars = String.graphemes(line)
    digits = Enum.reverse(Enum.map(chars, &elem(Integer.parse(&1), 0)))
    largest = largest_digit(line)
    largest_index = Enum.find_index(digits, fn x -> x == largest end)
    from_largest = Enum.slice(digits, (largest_index + 1)..-1//1)
    second_largest = largest_digit(Enum.join(from_largest))
    {n, _} = Integer.parse(Enum.join([second_largest, largest]))
    n
  end

  def largest_digit(bank) do
    chars = String.graphemes(bank)
    digits = Enum.map(chars, &elem(Integer.parse(&1), 0))
    List.first(Enum.sort(digits, :desc))
  end

  def largest_joltage2(line) do
    chars = String.graphemes(line)
    digits = Enum.map(chars, &elem(Integer.parse(&1), 0))
    find_best_num(digits, 12, 0, [])
  end

  def find_best_num(digits, rem, pos, batteries) do
    e = length(digits) - rem + 1
    best = Enum.max(Enum.slice(digits, pos..(e - 1)))
    new_pos = Enum.find_index(Enum.slice(digits, pos..(e - 1)), fn x -> x == best end) + 1
    cond do
      rem == 1 -> elem(Integer.parse(Enum.join(batteries ++ [best])), 0)
      true -> find_best_num(digits, rem - 1, new_pos + pos, batteries ++ [best])
    end
  end
end

input_file = File.read!("input.txt")

lines = String.split(input_file, "\n")

joltages = Enum.map(lines, &AOC.largest_joltage/1)
IO.inspect(Enum.sum(joltages))

joltages2 = Enum.map(lines, &AOC.largest_joltage2/1)
IO.inspect(Enum.sum(joltages2))
