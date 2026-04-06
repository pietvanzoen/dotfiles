if [ -f ~/.bashrc ]; then
  source ~/.bashrc
else
  echo "Could not find ~/.bashrc. Did you stow?"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/piet/.lmstudio/bin"
# End of LM Studio CLI section

