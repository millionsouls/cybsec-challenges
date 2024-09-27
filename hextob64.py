b64_table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
hex_str = "f348ad3849f8f393"

def hexb64(input):
    data = bytes(int(input[i:i+2], 16) for i in range(0, len(input), 2))
    val, bleft, result = 0, -6, []

    for byte in data:
        val = (val << 8) + byte
        bleft += 8

        while bleft >= 0:
            result.append(b64_table[(val >> bleft) & 0x3F])
            bleft -= 6

    if bleft > -6:
        result.append(b64_table[((val << 8) >> (bleft + 8)) & 0x3F])

    while len(result) % 4:
        result.append('=')

    return ''.join(result)


print(hexb64(hex_str))