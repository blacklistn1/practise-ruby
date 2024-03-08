# @param target [Numeric]
# @param lower_limit [Numeric]
# @param upper_limit [Numeric]
# @return [Numeric, Boolean]
def get_wrapped_code(target, lower_limit, upper_limit)
  if upper_limit <= lower_limit
    target
  else
    distance = upper_limit - lower_limit + 1
    if target > upper_limit
      target - (distance * ((target - upper_limit) / distance + 1))
    elsif target < lower_limit
      target + (distance * ((lower_limit - target) / distance + 1))
    else
      target
    end
  end
end

# @param target [String]
# @param factor [number]
# @return [String]
def caesar_cipher(target, factor)
  up_a_code = 'A'.ord
  up_z_code = 'Z'.ord
  down_a_code = 'a'.ord
  down_z_code = 'z'.ord
  result = ''

  target.each_char do |c|
    ch_code = c.ord
    changed_code = ch_code + factor
    p changed_code
    if ch_code >= up_a_code && ch_code <= up_z_code
      changed_letter = (get_wrapped_code(changed_code, up_a_code, up_z_code)).chr
    elsif ch_code >= down_a_code && ch_code <= down_z_code
      changed_letter = (get_wrapped_code(changed_code, down_a_code, down_z_code)).chr
    else
      changed_letter = ch_code.chr
    end
    result << changed_letter
  end

  return result
end

def main
  p caesar_cipher("Hello! I'm V.", 4)
end

main
