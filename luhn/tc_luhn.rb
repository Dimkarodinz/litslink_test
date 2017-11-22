#!/usr/bin/env ruby

require 'test/unit'
require_relative 'luhn'

class TestLuhnValid < Test::Unit::TestCase
  CARD = {
    valid: 371449635398431,
    invalid: 5141432423423423
  }

  def test_true_if_valid_card_number
    assert_equal(true, Luhn.valid?(CARD[:valid]))
  end

  def test_false_if_invalid_card_number
    assert_equal(false, Luhn.valid?(CARD[:invalid]))
  end
end

class TestLuhnCheckDigit < Test::Unit::TestCase
  CARD = {
    with_check: 79927398713,
    without_check: 7992739871
  }

  def test_number_with_test_digit
    assert_equal(CARD[:with_check], Luhn.with_check_digit(CARD[:without_check]))
  end
end
