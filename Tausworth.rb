# A Tausworth Pseudo-Random Number Generator implementation in ruby

# We first need a  sequence of q bits to be specified. 
# It should be noted that the important variables here are q and r. (both integers)
# they have the relationship 0 < r < q
class Tausworth
    @q = 0 #value of variable q
    @r = 0 #value of variable r
    @l = 0 #length of required bit strings
    @total_no_of_bits = 0 #total number of bits to be generated.

    def initialize(q, r, l, total_no_of_bits)
        @q = q
        @r = r
        @l = l
        @total_no_of_bits = total_no_of_bits
        initial_sequence = generate_initial_bit_sequence()
        @total_sequence = generate_total_bit_sequence(initial_sequence)
    end

    def generate_initial_bit_sequence()
        init_sequence = []
        for i in 0...@q
            init_sequence << Random.rand(0..1)
        end
        return init_sequence
    end


    #requires an initial bit sequence, the total number of bits.
    def generate_total_bit_sequence(initial_bits)
        intial_bits = initial_bits
        for i in (@q)..@total_no_of_bits
            initial_bits << (initial_bits[i-@r]+initial_bits[i-@q])%2
        end
        return initial_bits
    end

    #requires a bit string. Converts that bit string into random numbers. 
    def generate_random_numbers() 
        #The variable l is used to define the length of the binary integer.  
        #For instance, if l == 4, the the binary integers will be 4-bits long. 
        bit_string = @total_sequence
        start_point = 0
        end_point = @l-1
        random_numbers = []
        while end_point < bit_string.length
            current_bit_string = bit_string[start_point..end_point].join('')
            numerator = current_bit_string.to_i(2)
            random_numbers << numerator *1.0/ (2**@l)

            if bit_string.length - end_point < @l
                break
            else
                start_point = end_point + 1
                end_point = start_point + @l-1
            end
        end
        return random_numbers
    end
    
    #generates one random number with distribution U(0,1)
    def generate_one_random_number()
        @l = @total_no_of_bits + 1
        bit_string = @total_sequence.join('')
        numerator = bit_string.to_i(2)
        random_number = numerator *1.0 / 2**@l

        return random_number
    end

    def generate_random_number_in_range(min, max)
        @l = @total_no_of_bits + 1
        bit_string = @total_sequence.join('')
        numerator = bit_string.to_i(2)
        random_number = numerator *1.0 / 2**@l
        result = min + (random_number)*(max-min) 
        return result.to_i
    end
end

#The period is equivalent to (2**q -1) hence, for q = 5, the period is 31, and for q=7, the period is 127.
# The number of random numbers generated is equivalent to total_no_of_bits generated  divided by the length of a bits string, l

rng = Tausworth.new(5,3,7,42)
random_nums = rng.generate_random_numbers()
random_num = rng.generate_one_random_number()
random_num_ranged = rng.generate_random_number_in_range(30, 35)
puts "#{random_num_ranged}"
#puts "#{generate_random_numbers(@bit_string, 4)}"