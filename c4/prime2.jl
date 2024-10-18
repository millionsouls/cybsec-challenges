function xor_mult(a::Integer, b::Integer)
    return b % 2 * a + (b > 0 ? xor_mult(2 * a, b ÷ 2) : 0)
end

const xor_cache = Dict{Tuple{Int, Int}, Int}()

function xort2(a::Int, b::Int)
    key = (a, b)
    if haskey(xor_cache, key)
        return xor_cache[key]
    end

    result = b % 2 * a ⊻ (b > 0 ? xort2(2 * a, b ÷ 2) : 0)
    xor_cache[key] = result
    return result
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

xor_primes = find_xor_primes(100)
println("The first 10 XOR primes are: ", xor_primes)
