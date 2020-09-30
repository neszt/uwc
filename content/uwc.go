package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"sort"
)

type keylist struct {
	key    string
	counts int
}

func main() {
	// Ez itt a hash/map
	m := make(map[string]int)

	// Igy lesz pufferelt az Stdin (igy lesz gyors)
	stdin := bufio.NewReaderSize(os.Stdin, 1<<20)

	stdout := bufio.NewWriterSize(os.Stdout, 1<<20)
	defer stdout.Flush()

	exp := regexp.MustCompile("([a-zA-Z']+)")

	// A sorok beolvasasa
	for {
		line, err := stdin.ReadString(byte('\n'))
		if err != nil {
			break
		}
		for _, word := range exp.FindAllString(line, -1) {
			m[word]++
		}
	}

	// A kulcs/darabszamokbol lista keszitese
	list := make([]*keylist, 0, len(m))
	for k, c := range m {
		list = append(list, &keylist{k, c})
	}

	// A rendezes
	sort.Slice(list, func(i, j int) bool {
		return list[i].counts < list[j].counts || (list[i].counts == list[j].counts && list[i].key < list[j].key)
	})

	// Kiiras
	for _, kv := range list {
		stdout.WriteString(fmt.Sprintf("%s %d\n", kv.key, kv.counts))
	}
}
