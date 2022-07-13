#include<iostream>
#include<math.h>
#include<fstream>

using namespace std;

void lexicographically_smallest_powers_of_two(int number, int k){
    int j = 0;
    int a[k];
    int number_to_add = number - k;
    bool didnt_break = true;
if (k>number){
        cout << "[]" << endl;
        return;
    }
    for (int i = 0; i < k; i++){
        a[i] = 1;                //array with k elements all equal to 1
    }
    while (number_to_add != 0){  // total sum of the elements of a[] is K so i need number-K = (number_to_add) more to have sum = N
          int i = 0;             // 
      while(pow(2,i) <= number_to_add){ // find the power of 2 that is the closest to the number_to_add
          if (number_to_add == pow(2, i) and i!=0){  // when i find it... a[last element = 1] = power of two
            a[k-1-j] += pow(2, i) - 1;          
            j += 1;                                 // i find the last element by add 1 to j, last one will be at k-1-j
            number_to_add = number_to_add - pow(2, i) + 1; //the number_to_add gets smalles whenever we add power of 2 to the array
            didnt_break = false;
            break;
        }
        if (number_to_add == 1){
            a[k-1-j] += 1;
            number_to_add = 0;
            didnt_break = false;
            break;
        }
        i+=1;
      }
        if (number_to_add < pow(2, i) and didnt_break){
            if (number_to_add+1 == pow(2,i)){ 
                a[k-1-j] += number_to_add;
                break;
            }
            a[k-1-j] += pow(2, i-1) - 1;
            j += 1;
            number_to_add = number_to_add - pow(2, i-1) + 1;
        }
        if (k-1-j < 0){
            cout << "[]" << endl;
            return;
        }
        didnt_break = true;
    }
    int i = 0;
    int t = 0;
    int final_output[k]; for(int i =0; i < k; i++) final_output[i] = 0;
    cout << "[";
    while(i<k){
        if (a[i] == pow(2,t)){
            final_output[t] += 1;
            i += 1;
        }
        else if (a[i] > pow(2,t)){
            cout << final_output[t] << ",";
            t += 1;
        }
    }
    cout << final_output[t];
    cout << "]" << endl;
    return;
}
int main(int argc, char **argv){
    int T, number, k;
    ifstream inFile;
    inFile.open(argv[1]);
    inFile >> T;
for (int i = 0; i < T; i++){
     inFile >> number;
     inFile >> k;
    lexicographically_smallest_powers_of_two(number, k); 
}
    return 0;
}