package main

import (
	"bufio"
	"encoding/hex"
	"fmt"
	"math"
	"os"
	"sort"
)

type TextEntropy struct {
	Text    string
	dText   string
	Entropy float64
}

func ShannonEntropyByte(str []byte) float64 {
	// str = strings.ToLower(str)
	totalChars := len(str)
	entropy := 0.0

	freq := make(map[byte]int)
	for _, char := range str {
		freq[char]++
	}

	for _, count := range freq {
		prob := float64(count) / float64(totalChars)

		if prob > 0 {
			entropy -= prob * math.Log2(prob)
		}
	}

	return (entropy)
}

func main() {
	data, err := os.Open("data.txt")

	if err != nil {
		panic(err)
	}

	var results []TextEntropy
	scanner := bufio.NewScanner(data)
	for line := 0; scanner.Scan(); line++ {
		text := scanner.Text()

		//num := entropy([]byte(text))
		//fmt.Println(num, " ", line)

		dco, _ := hex.DecodeString(text)
		entropy := ShannonEntropyByte([]byte(text))
		results = append(results, TextEntropy{Text: text, dText: string(dco), Entropy: entropy})

		//fmt.Printf("%.4f\n", entropy)
		//fmt.Printf("%f %s\n", num, dco)
	}

	defer data.Close()

	sort.Slice(results, func(i, j int) bool { return results[i].Entropy < results[j].Entropy })

	for _, result := range results {
		fmt.Printf("%s %s %f\n", result.Text, result.dText, result.Entropy)
	}
}
