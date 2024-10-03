package main

import (
	"bufio"
	"encoding/hex"
	"fmt"
	"math"
	"os"
	"sort"
	"strings"
)

type TextEntropy struct {
	Text    string
	dText   string
	Entropy float64
}

func ShannonEntropy(str string) float64 {
	str = strings.ToLower(str)
	totalChars := len(str)
	entropy := 0.0

	freq := make(map[rune]int)
	for _, char := range str {
		if char >= 'a' && char <= 'z' {
			freq[char]++
		}
	}

	for _, count := range freq {
		prob := float64(count) / float64(totalChars)

		if prob > 0 {
			entropy -= prob * math.Log2(prob)
		}
	}

	/*
		maxEntropy := math.Log2(float64(totalChars))

		if maxEntropy == 0 {
			return 0
		}
	*/

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

		//dco, _ := hex.DecodeString(text)
		//entropy := ShannonEntropyBytes([]byte(text))
		entropy := ShannonEntropy(text)
		results = append(results, TextEntropy{Text: text, Entropy: entropy})

		//fmt.Printf("%.4f\n", entropy)
		// mt.Printf("%f %s\n", num, dco)
	}

	defer data.Close()

	sort.Slice(results, func(i, j int) bool { return results[i].Entropy < results[j].Entropy })

	for _, result := range results {
		fmt.Printf("%s %s %f\n", result.Text, result.dText, result.Entropy)
	}

	dco, _ := hex.DecodeString(results[0].Text)

	fmt.Printf("Possible String: %s\n", string(dco))
}
