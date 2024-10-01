package main

import (
	"bufio"
	"encoding/hex"
	"fmt"
	"math"
	"os"
)

// sum(f * log(f, 2)) for some f frequencies

func entropy(data []byte) float64 {
	var score float64
	var freqArray [256]float64

	for i := 0; i < len(data); i++ {
		freqArray[data[i]]++
	}

	len := float64(len(data))

	for i := 0; i < 256; i++ {
		if freqArray[i] != 0 {
			freq := freqArray[i] / len
			score -= freq * math.Log2(freq)
		}
	}

	return score / 8
}

func main() {
	data, err := os.Open("data.txt")
	frequencies := make(map[int]string)

	if err != nil {
		panic(err)
	}

	scanner := bufio.NewScanner(data)
	for line := 0; scanner.Scan(); line++ {
		text := scanner.Text()

		num := entropy([]byte(text))
		// fmt.Println(num, " ", line)

		dco, _ := hex.DecodeString(text)
		// fmt.Println(string(dco))

		fmt.Printf("%f %s\n", num, dco)

		frequencies[line] = fmt.Sprintf("%f ", num) + string(dco)
	}

	// fmt.Println(frequencies)

	defer data.Close()
}
