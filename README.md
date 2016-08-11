# RomeBuild
### A CLI tool that uses [Carthage](https://github.com/Carthage/Carthage) dependency resolution and building to deliver pre-built dependencies through [Rome Server](https://github.com/146BC/Rome)

![Demo](http://i.imgur.com/dfCKwbR.gif)

RomeBuild gives everyone the ability to store & reuse pre-built dependencies. To get started clone [Rome Server](https://github.com/146BC/Rome), set it up following this [guide](https://github.com/146BC/Rome/blob/master/README.md) and then run `romebuild -u` to build, package and store all the dependencies in Rome Server, the next time you run `romebuild -b` all dependencies will be fetched from Rome Server reducing build time to just a couple of seconds.

Environment variables `ROME_ENDPOINT` (Ex: http://localhost:3000/) & `ROME_KEY` (Client API Key) need to be set in order for RomeBuild to connect to Rome Server.

### Installation

`brew install 146BC/repo/romebuild`

### Usage examples

`romebuild --build`

Fetches dependencies from a Rome Server & builds the rest using *carthage build*

`romebuild --build --platform ios,osx`

Fetches dependencies from a Rome Server & builds the rest using *carthage build --platform ios,osx*

`romebuild --upload`

Builds dependencies that are not available on Rome Server using: *carthage build dependency-name --no-skip-current* and *carthage archive dependency-name* then uploads every dependency on Rome Server

All commands use Cartfile.resolved as a reference, if the file is not present a new one will be generated.