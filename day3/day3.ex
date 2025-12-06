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
end

input_file = File.read!("input.txt")

lines = String.split(input_file, "\n")

joltages = Enum.map(lines, &AOC.largest_joltage/1)
IO.inspect(Enum.sum(joltages))
