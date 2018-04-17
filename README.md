# PowerCLI-InSpec Container

## Scope

This container is combination of the PowerCLI and InSpec systems for convenience.

### Note
This is *NOT* good for production at this release, we will remove this note if it is ready for production.
This is a proof of concept and a way to show off using InSpec to call PowerCLI.

## Usage

Pull the container down into your docker local register:

```bash
docker pull jjasghar/playingwithinspec
```

Run the container from the directory you have some InSpec profiles you'd like to run:

```bash
docker run -v ${PWD}:/root/profiles -it jjasghar/playingwithinspec
```

## License and Author

- Author::  JJ Asghar <jj@chef.io>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
