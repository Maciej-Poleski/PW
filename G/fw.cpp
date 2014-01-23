#include <climits>
#include <cstdio>

inline int get(int * graph, int i, int j, int N) {
    return graph[i + j * N];
}

inline void set(int * graph, int i, int j, int N, int v) {
    graph[i + j * N] = v;
}

int fw(int * graph, int N, int * taskSizes, int ** taskElements, int K) {

    int max = INT_MIN;

#pragma omp parallel
    for (int k = 0; k < N; ++k) {
#pragma omp for collapse(2)
        for (int j = 0; j < N; ++j) {
            for (int i = 0; i < N; ++i) {
                int temp = get(graph, i, k, N) + get(graph, k, j, N);
                if (temp < get(graph, i, j, N)) {
                    set(graph, i, j, N, temp);
                }
            }
        }
    }

#pragma omp parallel
{
    for (int i = 0; i < K; ++i) {

        int taskSize = taskSizes[i];
        int * task = taskElements[i];

#pragma omp task
        for (int j = 0; j < taskSize; ++j) {
            int localMax = INT_MIN;
            for (int k = 0; k < taskSize; ++k) {
                for (int l = 0; l < taskSize; ++l) {

                    int temp = get(graph, task[j], task[k], N);
                    temp += get(graph, task[k], task[l], N);
                    temp += get(graph, task[l], task[j], N);

                    if (temp > localMax) {
                        localMax = temp;
                    }

                }
            }

            if (localMax > max) {
                max = localMax;
            }
        }

    }
}

    return max;
}

