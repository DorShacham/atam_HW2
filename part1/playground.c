#include <stdio.h>
#include <stdlib.h>

int get_elemnt_from_matrix(int* matrix, int n, int row, int col);
void multiplyMatrices(int* first, int* second, int* result, int m, int n, int r, unsigned int p);

void set_elemnt_in_matrix(int* matrix, int num_of_columns, int row, int col, int value) {
   *((matrix + row*num_of_columns) + col) = value;
}

void tryGetElement() {
    int matrix[] = {
        1,2,3,
        4,5,6,
        7,8,9
    };

    int element = get_elemnt_from_matrix((int*)matrix, 3, 2, 1);

    printf("%d\n", element);
}

void tryMultiplyMatrices() {
    int matrix1[] = {
        2,4,5,
        5,2,7
    };
    int matrix2[] = {
        4,1,
        1,3,
        6,0
    };
    int *res = (int*)malloc(sizeof(int)*2*2);
    multiplyMatrices((int*)matrix1, (int*)matrix2, res, 2, 3, 2, 5);

    printf("%d %d\n%d %d\n", res[0], res[1], res[2], res[3]);
}

int main() {
    tryMultiplyMatrices();
}

