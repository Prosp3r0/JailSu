#include <spawn.h>
#include <stdlib.h>

extern char **environ;

void run_cmd(char *cmd);

int  main(int argc, char *argv[], char *envp[])
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (argc < 2)
    {
        fprintf(stderr, "usage: %s program args...\n", argv[0]);
        return EXIT_FAILURE;
    }
    
    int ret, status;
    pid_t pid;
    posix_spawnattr_t attr;
    
    posix_spawnattr_init(&attr);
    posix_spawnattr_setflags(&attr, POSIX_SPAWN_START_SUSPENDED);
    
    ret = posix_spawnp(&pid, argv[1], NULL, &attr, &argv[1], envp);
    
    posix_spawnattr_destroy(&attr);
    
    if (ret != 0)
    {
        printf("posix_spawnp failed with %d: %s\n", ret, strerror(ret));
        return ret;
    }
    
    char buf[200];
    
    snprintf(buf, sizeof(buf), "/electra/jailbreakd_client %d 1", pid);
    //system(buf);
    run_cmd(buf);

    
    kill(pid, SIGCONT);
    waitpid(pid, &status, 0);
    
    return 0;
    #pragma clang diagnostic pop
}

void run_cmd(char *cmd)
{
    pid_t pid;
    char *argv[] = {"sh", "-c", cmd, NULL};
    int status;

    status = posix_spawn(&pid, "/bin/sh", NULL, NULL, argv, environ);
    if (status == 0) {
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
        }
    }
}