#!/bin/sh

if [ -n "$GITHUB_API_KEY" ]; then
    cd "$TRAVIS_BUILD_DIR"
    
    REPO=`git config remote.origin.url`
	
    REPO_URL=`echo $REPO | awk -F':' '{print $2}' | awk -v key="$GITHUB_API_KEY" -F'/' '{print "https://"$1":"key"@github.com/"$2}'`
    
    # This generates a `web` directory containing the website.
    cd public
    git init
    git checkout -b gh-pages
    git add .
    git -c user.name='travis' -c user.email='travis' commit -m init

    # Make sure to make the output quiet, or else the API token will leak!
    # This works because the API key can replace your password.
    git push -f -q $REPO_URL gh-pages &2>/dev/null
    cd "$TRAVIS_BUILD_DIR"
fi