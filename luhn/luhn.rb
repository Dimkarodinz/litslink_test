class Luhn
  class << self

    # returns true or false depending on whether the number is a valid number
    def valid?(number)
      control_sum(number) % 10 == 0
    end

    # calculates the Luhn check digit and returns
    # the original number with the check digit appended on the end
    def with_check_digit(number)
      sum = control_sum(number)
      check_digit = to_a(sum * 9).last
      to_a(number).push(check_digit).join.to_i
    end

    private

    def control_sum(number)
      numbers   = to_a(number)
      double    = double_even_numbers(numbers)
      substract = substracted_array(double)
      substract.inject(:+)
    end

    def to_a(number)
      number.to_s.chars.map(&:to_i)
    end

    # double even numbers of array
    def double_even_numbers(array)
      doubled_array = array.clone

      (array.length - 1).step(0, -2) do |i|
        doubled_array[i] += doubled_array[i]
      end

      doubled_array
    end

    # substract 9 if number in array is greater that it
    def substracted_array(array)
      sub_array = array.clone

      (sub_array.length).step(0, -1) do |i|
        sub_array[i] -= 9 if sub_array[i] > 9
      end      

      sub_array
    end

  end
end
