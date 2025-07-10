#include <stdlib.h>
#include <unistd.h>

int main() {
    if (fork() > 0) {
        // parent: sleep forever, keeping child in zombie
        sleep(1000);
    } else {
        // child: exit immediately
        exit(0);
    }
}
