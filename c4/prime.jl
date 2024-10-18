function xort2(a, b)
    return b % 2 * a ⊻ (b > 0 && xort2(2a, b ÷ 2))
end

function is_xor_prime(n::Integer)
    for a in 2:n-1
        for b in 1:n-1
            if xort2(a, b) == n
                return false
            end
        end
    end
    return true 
end

function find_xor_primes(count::Int)
    xor_primes = []
    num = 2 

    while length(xor_primes) < count
        if is_xor_prime(num)
            push!(xor_primes, num)
        end
        num += 1
    end

    return xor_primes
end

println(xort2(3,3))
@time xor_primes = find_xor_primes(100)
println("Results: ", xor_primes)