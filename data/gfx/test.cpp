#include<iostream>
#include<fstream>
#include<algorithm>
#include<sstream>

int main(int argc, char **argv) {

	std::ifstream fin("test.txt");
	if(!fin.is_open()) 
		return 0;

	std::string s;
	while(std::getline(fin, s)) {
		std::ostringstream stream;
		stream << "cp " << s << " files/" << s;
		std::cout << stream.str();
		system(stream.str().c_str());
	}

}
