# Dartcrawler
**Author:** Gray

**License:** [MIT License](#License "MIT License")

**Description:** Easy to use async url spidering tool with advanced capabilities. Dartcrawler is a cross platform tool written in dart with significant performance enhancements that really make it an effective choice over pre-existing tools.

## Installation
```sh
# Download the repository with
$ git clone https://github.com/GrayWasTaken/dartcrawler.git

# Option 1: Run using pre-built binary.
# By default Dartcrawler comes with a prebuilt binary to execute.
$ ./dartcrawler/bin/dartcrawler

# Option 2: Build your own binary from source.
# Make sure you have the dart sdk installed and corresponding dependencies.
$ cd dartcrawler/
$ pub get
$ dart2native ./bin/dartcrawler.dart -o bin/dartcrawler
```

## Screenshots
![1](https://lambda.black/assets/portfolio/dartbuster/1.png "Help Screen")
![2](https://lambda.black/assets/portfolio/dartbuster/2.png "Scan in progress")
![3](https://lambda.black/assets/portfolio/dartbuster/3.png "Scan completion")
![4](https://lambda.black/assets/portfolio/dartbuster/4.png "Word and extension lists")
![6](https://lambda.black/assets/portfolio/dartbuster/5.png "User agents list")

## Features
- Real time scan progress and information
- Built in user agents
- Rotates user agent per request (optional)
- Specify delay
- Specify timeout
- Scans all urls present on a page
- Same and multi-domain support
- Supports output files
- Supports exclusions
- Specify custom cookies
- Automatically skips common webserver traps such as endless redirects and optionally prints to screen
- Pre and post scan report
- Fully cross platform
- Asynchronous by nature so multiple requests will occur concurrently on a single thread

## Usage
***The help screen has all the information you'd need, but here are some hopefully useful examples:***


```py
# Prints help screen
$ dartcrawler -h

# Starts crawling the "example.com" website, with 2 cookies user, and pass
$ dartcrawler scan -u https://example.com -c user=member;pass=default

# Starts crawling the "example.com" website, with the exclusions .png, .jpeg, .jpg
$ dartcrawler scan -u https://example.com -e .png,.jpeg,.jpg

# Prints built in useragents
$ dartcrawler useragents
```

## Todo List
- Possibly stop get requests where the fetched content exceeds a certain size, ie: if webserver starts an endless file stream.
- Implement isolates 2.
- Implement in progress \r message like in buster.


## License
MIT License

Copyright (c) 2020 Gray

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
