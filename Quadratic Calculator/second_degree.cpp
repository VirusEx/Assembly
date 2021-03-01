// ****************************************************************************************************************************
// Program name: "Quadratic Calculator".  This program calculate if there exist two roots, one root, or no root in a qudratic *
// equation. This program also validate if the user inputs are valid float number and return error message if invalid inputs  *
// are found.  Copyright (C) 2021 Danny Ng.                                                                                   *
//                                                                                                                            *
// This file is part of the software program "Quadratic Calculator".                                                          *
// Quadratic Calculator is free software: you can redistribute it and/or modify it under the terms of the GNU General Public  *
// License version 3 as published by the Free Software Foundation.                                                            *
// Quadratic Calculator is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied *
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
// A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
// ****************************************************************************************************************************


// ========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
// 
// Author information
//   Author name: Danny Ng
//   Author email: dannyng@csu.fullerton.edu
// 
// Program information
//   Program name: Quadratic Calculator
//   Programming languages: Three modules in C++ and one module in X86
//   Date program began: 2021-Feb-28
//   Date of last update: 2021-Feb-28
//   Date of reorganization of comments: 2021-Feb-28
//   Files in this program: second_degree.cpp, quadratic.asm, quadLibrary.cpp, isfloat.cpp
//   Status: In testing phase
// 
// This file
//    File name: second_degree.cpp
//    Language: C++
//    Max page width: 132 columns
//   Compile: g++ -c -m64 -Wall -fno-pie -no-pie -o drive.o second_degree.cpp -std=c++17
//   Link: g++ -m64 -fno-pie -no-pie -o code.out -std=c++17 scan.o quadratic.o drive.o quad.o

// ===== Begin code area ==============================================================================================================


#include <iostream>

extern "C" double root();

int main(){
    double result=0.0;
    printf("Welcome to Root Calculator\nProgrammed by Danny Ng, Professional Programmer.\n\n");
    result=root();
    printf("The main driver received %8.10lf and has decided to keep it.\n",result);
    printf("Now 0 will be returned to the operating system.  Have a nice day.  Bye.\n");
    return 0;
}