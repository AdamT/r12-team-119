class Intersection
  def demo_method
    users = Hash.new

    LENGTH       = 12
    MIN_DURATION = 3

    users["adam"]  = "1111110111110"
    users["jason"] = "1111111100010"
    users["david"] = "1100111111110"

    users.size.downto(2) do |n|
      found = false

      users.keys.combination(n).to_a.each do |subgroup|
        intersection = subgroup.inject(("1" * LENGTH).to_i(2)) do |x, user|
          x &= users[user].to_i(2)
        end.to_s(2)

        intersection.gsub!(/(?:^|0)(1{1,#{MIN_DURATION-1}})(?:0|$)/, "0" * '\1'.length)

        if intersection =~ /1{#{MIN_DURATION}}/
          found = true

          puts subgroup.sort.inspect
          puts intersection.rjust(LENGTH, "0")
        end
      end

      break if found
    end
    found
  end
end
