b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
hexStr = "f348ad3849f8f393"

def hexb64(input):
    data = bytes(int(input[i:i+2], 16) for i in range(0, len(input), 2))
    val, buff, result = 0, -6, []

    for byte in data:
        val = (val << 8) + byte
        buff += 8

        while buff >= 0:
            result.append(b64[(val >> buff) & 0x3F])
            buff -= 6

    if buff > -6:
        result.append(b64[((val << 8) >> (buff + 8)) & 0x3F])

    while len(result) % 4:
        result.append('=')

    return ''.join(result)


print(hexb64(hexStr))