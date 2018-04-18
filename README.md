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

### Demo Controls

We have added some demo controls [`controls/`](./controls). There are two, one to check for SSH disabled on an ESXi
host, and the second to check that a CDROM is not attached to a VM.

You will need to create a password `yaml` file to connect as, for example `esxi.yaml`:

```yaml
viserver: esxi-01.chef.io
username: root
password: Cod3Can!
virtualmachine: vm-name
```

If the virtualmachine property is missing, all VMs will be checked. The virtualmachine attribute can be used to specify one or more VMs. Seperate multiple VM names with a comma vm1,vm2.

After this, you can run these tests via:

```shell
docker run -v ${PWD}:/root/profiles -it jjasghar/playingwithinspec
inspec exec controls/ --attrs esxi.yaml
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
