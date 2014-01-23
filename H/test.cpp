#include <cstdio>
#include <cstdlib>
#include "radius.h"

void gen(int seed, int* graph, int N, int dens, int spread)
{
    srand(seed);

    for (int i = 0; i < N * N; ++i) {
        graph[i] = 100000000;
    }
    for (int i = 0; i < dens; ++i) {
        int x = rand() % N;
        int y = rand() % N;
        if (x != y) {
            int dist = (rand() % spread) + 1;
            graph[x + y * N] = dist;
            graph[y + x * N] = dist;
        }
    }

    for (int i = 0; i < N; ++i) {
        graph[i + i * N] = 0;
    }
}
int main()
{
    int n = 1024;
    int* graph = (int*)malloc(n * n * sizeof(int));
    gen(12345, graph, n, 32000, 200);
    int rad = radius(graph, n);
    printf("%d\n",rad);
}
