# zsh
This is a configuration file for zsh I have been developing with
with OpenBSD in mind, so you might want to check that this and 
that works for you as well, if you want to use it. 

The prompt is thought to display the hostname, the time on the right
and the port. On a line spanning all of the available space, you have
the full path of your current directory (useful to copy and paste to
change swiftly back and forth between different folders). Since I have
many sublevels, I need it to span as much available space as possible.
Have a look at the snapshot for an impression.

![prompt_pau](https://github.com/user-attachments/assets/3472574b-de86-4533-a356-8fec9082b3a0)


For the prompt to work, you need the file "prompt_pau" to be located
in the same folder as your zshrc, and then in the zshrc file, add
```
autoload -U promptinit
promptinit
prompt pau grey grey grey grey grey grey,bold
```

Pau Amaro Seoane, 2003-2025
