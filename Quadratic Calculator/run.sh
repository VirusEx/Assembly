rm *.o
rm *.out

g++ -c -m64 -Wall -fno-pie -no-pie -o scan.o isfloat.cpp -std=c++17

g++ -c -m64 -Wall -fno-pie -no-pie -o quad.o quadLibrary.cpp -std=c++17

nasm -f elf64 -o quadratic.o quadratic.asm

g++ -c -m64 -Wall -fno-pie -no-pie -o drive.o second_degree.cpp -std=c++17

g++ -m64 -fno-pie -no-pie -o code.out -std=c++17 scan.o quadratic.o drive.o quad.o

./code.out