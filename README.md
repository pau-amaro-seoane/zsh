# zsh
This is a simple configuration file for zsh. It has been developed
with OpenBSD in mind, so you might want to check that this and 
that works for you as well, if you want to use it.

For the prompt to work, you need the file "prompt_pau" to be located
in the same folder as your zshrc, and then in the zshrc file, add
```
autoload -U promptinit
promptinit
prompt pau grey grey grey grey grey grey,bold
```

Pau Amaro Seoane, 2003-2025
