#include <stdio.h>

int get_elemnt_from_matrix(int* matrix, int n, int row, int col);

int main() {
    int matrix[] = {
        1,2,3,
        4,5,6,
        7,8,9
    };

    int element = get_elemnt_from_matrix((int*)matrix, 3, 2, 1);

    printf("%d\n", element);
}

