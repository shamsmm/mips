int main() {
    for (int i = 0; i < 10; i ++) {
        int a = 1 , b = 2, c = 3, d = 4;
        a = b + d;
        d = a - d;

        if (a == d)
            c = 5;
        else
            c = 2;
    }

    for (;;) {
    }
}