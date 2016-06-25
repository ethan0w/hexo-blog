#!/bin/sh

#you need to generate a token on github.com and set Environment Variables on travis-ci.org

if [ -n "$GITHUB_API_KEY" ]; then
    cd "$TRAVIS_BUILD_DIR"
    
    REPO=`git config remote.origin.url`
    echo "origin url:$REPO"
	
    REPO_URL=`echo $REPO | awk -F':' '{print $2}' | awk -v key="$GITHUB_API_KEY" -F'/' '{print "https://"$1":"key"@github.com/"$0}'`
    
    # This generates a `web` directory containing the website.
    cd public
	
    echo "init git repo now"
    git init
    git checkout -b gh-pages
    git add .
    
    DATE="`date +%Y-%m-%d` `date +%H:%M:%S`"
    MSG="rev:$DATE"

    echo "commit to local repo, message:$MSG"
    git -c user.name='travis' -c user.email='travis' commit -m "$MSG"

    echo "push to github now"    
    git push -f $REPO_URL gh-pages
    cd "$TRAVIS_BUILD_DIR"
else
    echo "GITHUB_API_KEY is empty"
fi
