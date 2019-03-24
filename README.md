# Installing

1. Clone this repo somewhere.
2. Add the `bin/` directory to your path.

# Usage

`cy` will pass through any arguments to `yarn` within the container. So for
example, if you have a script in your `package.json` for running cypress, you
would run `cy name-of-cypress-script`. Or, if you want to give cypress a command
directly, you could run `cy cypress open`, for example.

`cy` relies on having a docker container built for the version of cypress in use
by the current project (based on the directory you're running it from). You can
easily build the docker container for any version of cypress using `cy-build
CYPRESS_VERSION`, where `CYPRESS_VERSION` is the version of cypress you want a
docker container for.
