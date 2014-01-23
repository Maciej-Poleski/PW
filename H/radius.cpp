#pragma GCC optimize(3)

#include <limits>

inline int get(int* graph, int i, int j, int N)
{
    return graph[i + j * N];
}

inline void set(int* graph, int i, int j, int N, int v)
{
    graph[i + j * N] = v;
}

int radius(int* const graph, int const N)
{
    int min = std::numeric_limits<int>::max();
    #pragma omp parallel
    {
        for (int k = 0; k < N; ++k) {
            #pragma omp for
            for (int j = 0; j < N; ++j) {
                for (int i = 0; i < N; ++i) {
                    int temp = get(graph, i, k, N) + get(graph, k, j, N);
                    if (temp < get(graph, i, j, N)) {
                        set(graph, i, j, N, temp);
                    }
                }
            }
        }

        #pragma omp for
        for (int i = 0; i < N; ++i) {
            int max = 0;
            for (int j = 0; j < N; ++j) {
                if (i == j)
                    continue;
                if (max < get(graph, j, i, N))
                    max = get(graph, j, i, N);
            }
            #pragma omp critical
            if (min > max)
                min = max;
        }
    }
    return min;
}
