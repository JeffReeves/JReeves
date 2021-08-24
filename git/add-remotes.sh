#!/bin/bash
# purpose: add all remotes for repo
# author: Jeff Reeves

# define repository's stub for the URL
REPO_STUB='JReeves'

# create the repo directory on bridges
ssh git@bridges "mkdir /git/JReeves.git && cd /git/JReeves.git && git config --global init.defaultBranch main && git init --bare && sed -i 's/master/main/' /git/rpi4-custom-os.git/HEAD"

# add bridges to git remote list
git remote add bridges git@bridges:/git/JReeves.git

# add gitlab to git remote list
git remote add gitlab git@gitlab.com:JeffReeves/JReeves.git

# add github to git remote list
git remote add github git@github.com:JeffReeves/JReeves.git

# update origin to bridges
git remote set-url origin git@bridges:/git/JReeves.git

# view all remotes
git remote -v

# open settings for gitlab and github in browser
#explorer.exe "https://gitlab.com/JeffReeves/JReeves/-/settings/repository"
#explorer.exe "https://gitlab.com/JeffReeves/JReeves/-/branches"
#explorer.exe "https://github.com/JeffReeves/JReeves/settings/branches"
#explorer.exe "https://github.com/JeffReeves/JReeves/branches"

