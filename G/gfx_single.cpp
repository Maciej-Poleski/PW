#include <cstdio>


inline int get(int * bitmap, int x, int y, int N) {
    return bitmap[x + y*N];
}

inline int set(int * bitmap, int x, int y, int N, int v) {
    bitmap[x + y*N] = v;
}

void calc_sobel(int * bitmap, int * sobel, int N) {

    for (int i = 0; i < N; ++i) {
        set(sobel, i, 0, N, 0);
        set(sobel, i, N-1, N, 0);
        set(sobel, 0, i, N, 0);
        set(sobel, N-1, i, N, 0);
    }

    for (int y = 1; y < N-1; ++y) {
        for(int x = 1; x < N-1; ++x) {

            int temp = get(bitmap, x-1, y, N) - get(bitmap, x+1, y, N)
            + get (bitmap, x, y-1, N) - get(bitmap, x, y+1, N);
            set(sobel, x, y, N, temp);

        }
    }
}

void calc_blur(int * bitmap, int * blur, int N) {

    for (int i = 0; i < N; ++i) {
        set(blur, i, 0, N, 0);
        set(blur, i, N-1, N, 0);
        set(blur, 0, i, N, 0);
        set(blur, N-1, i, N, 0);
    }

    for (int y = 1; y < N-1; ++y) {
        for(int x = 1; x < N-1; ++x) {

            int temp = get(bitmap, x-1, y, N) + get(bitmap, x+1, y, N)
            + get (bitmap, x, y-1, N) + get(bitmap, x, y+1, N);
            set(blur, x, y, N, temp / 4);

        }
    }

}

int hash(int * bitmap, int N) {

    int h = 1234567;

    for (int x = 0; x < 20; ++x)
        for (int i = 0; i < N*N; ++i) {
            h = (bitmap[i] * h + 171713) % 7777777;
        }

        return h;

}

int process_bitmap(int * bitmap, int N) {

    int * sobel = new int[N*N];
    int * blur = new int[N*N];

    calc_sobel(bitmap, sobel, N);

    calc_blur(bitmap, blur, N);

    int hash1 = 0;
    int hash2 = 0;
    int hash3 = 0;

    hash1 = hash(sobel, N);
    hash2 = hash(blur, N);
    hash3 = hash(bitmap, N);

    delete [] sobel;
    delete [] blur;

    return hash1 + hash2 + hash3;
}

