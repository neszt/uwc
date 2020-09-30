#include <regex>
#include <unordered_map>
#include <string>
#include <iostream>
#include <typeinfo>

typedef std::unordered_map<std::string, int> hash_t;

int main()
{
	std::cin.sync_with_stdio(false);
	std::cout.sync_with_stdio(false);
	std::regex pattern("[a-z']+", std::regex_constants::ECMAScript | std::regex_constants::icase);
	std::cregex_iterator e;
	hash_t hash;

	while (!std::cin.eof()) {
		char buf[1024];
		std::cin.getline(buf, sizeof(buf));

		for (auto i = std::cregex_iterator(buf, buf + ::strlen(buf), pattern); i != e; ++i) {
			++hash[(*i).str()];
		}
	}

	std::vector<std::string> words;
	for (const auto& e : hash) {
		words.push_back(e.first);
	}

	std::sort(words.begin(), words.end(), [&hash] (const std::string& a, const std::string& b) -> bool {
			int diff = hash[a] - hash[b];
			return (diff < 0) || (diff == 0 && a < b); // (a.compare(b) < 0);
	});

	for (const auto& e : words) {
		std::cout << e << " " << hash[e] << "\n";
	}
}

// clang++ -O2 -o uwc.exe uwc.cpp -std=c++11 -stdlib=libc++
