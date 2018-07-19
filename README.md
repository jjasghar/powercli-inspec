# PowerCLI-InSpec

# NOTE: Please look at https://github.com/inspec/inspec-vmware from now on. This is an out of date example.

## Scope

This has some examples and custom resources for InSpec to work with PowerCLI.

## Usage

If you would like to just run this, I have an example profile set up [here](https://github.com/jjasghar/powercli-inspec-example).

### powercli_command

```ruby
# We expect TSM-SSH NOT to be running here.
conn_options = {
  viserver: attribute('viserver', description: 'The server you want to connect to'),
  username: attribute('username', description: 'Username to connect as'),
  password: attribute('password', description: 'Password to connect with')
}

cmd = 'Get-VMhost | Get-VMHostService | Where {$_.key -eq "TSM-SSH" -and $_.running -eq $False}'
describe powercli_command(cmd, conn_options) do
  its('exit_status') { should cmp 0 }
  its('stdout') { should_not be_empty }
end
```

Here is custom resource that allows you to write arbitrary PowerCLI commands to verify your VMware DataCenters. Above
is an example to check an ESXi host to verify that the `TSM-SSH` service is `OFF`.

### Self-Signed Certs

If you have self signed certificates on your ESXi/vCenter instances you will need to run the following commands from the
host you want to run InSpec from.

```powershell
$ pwsh
PS >  Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
```

If you don't the initial `Connect-VIserver` will fail with not being able to find PowerShell.

### Demo Controls

We have added some demo controls [`controls/`](./controls). There are two, one to check for SSH disabled on an ESXi
host, and the second to check that a CDROM is not attached to a VM.

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
