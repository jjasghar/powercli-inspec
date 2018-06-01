# PowerCLI-InSpec

## Scope

This has some examples and custom resources for InSpec to work with PowerCLI.

## Usage

### powercli_command

```ruby
# We expect TSM-SSH NOT to be running here.
cmd = 'Get-VMhost | Get-VMHostService | Where {$_.key -eq "TSM-SSH" -and $_.running -eq $False}'
conn_options = {
  viserver: attribute('viserver', description: 'The server you want to connect to'),
  username: attribute('username', description: 'Username to connect as'),
  password: attribute('password', description: 'Password to connect with')
}
describe powercli_command(cmd, conn_options) do
  its('exit_status') { should cmp 0 }
  its('stdout') { should_not cmp '' }
end
```

Here is custom resource that allows you to write arbitrary PowerCLI commands to verify your VMware DataCenters. Above
is an example to check an ESXi host to verify that the `TSM-SSH` service is `OFF`.

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
