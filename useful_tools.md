# Useful Tools

## command line

### tldr
    
too long; don't read.
It is a substitute of `man`.

```shell
$ sudo apt install -y tldr

$ tldr <command>
```
You could also use the `npm` to install this.

### tmux

terminal multiplexer. You'd better use `.tmux.conf`, Haha.

```shell
$ sudo apt install -y tmux

$ tmux list-session
$ tmux ls
$ tmux new-session -s
$ tmux attach
$ tmux attach -t
```

## programming tool

### Doxygen

doc generation.

```shell
$ sudo apt install -y doxygen

# generate an Doxyfile file.
$ doxygen -g
$ vim Doxyfile # `EXTRACT_ALL, EXTRACT_PRIVATE, RECURSIVE, HAVE_DOT, CALL_GRAPH, CALLER_GRAPH`;
               # make sure these options are all set to `YES` that extract all entites from
               # the code, even in subdirectories, and that call graphs are generated.
$ doxygen Doxyfile # generate the documentation in `html` directory.
```
