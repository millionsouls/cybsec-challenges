b64_table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
hex_str = "49276d20616c697665"

def hexb64(input):
    hex_bytes = bytes.fromhex(input)
    val, valb, result = 0, -6, []
    for byte in hex_bytes:
        val = (val << 8) + byte
        valb += 8
        while valb >= 0:
            result.append(b64_table[(val >> valb) & 0x3F])
            valb -= 6
    if valb > -6:
        result.append(b64_table[((val << 8) >> (valb + 8)) & 0x3F])
    while len(result) % 4:
        result.append('=')
    return ''.join(result)


print(hexb64(hex_str))