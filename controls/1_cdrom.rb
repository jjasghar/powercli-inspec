# frozen_string_literal: true

cmd = 'get-vm | Get-CDDrive | select connectionstate | Where {$_.ConnectionState -eq "Connected"}'
conn_options = {
  viserver: attribute('viserver', description: 'The server you want to connect to'),
  username: attribute('username', description: 'Username to connect as'),
  password: attribute('password', description: 'Password to connect with')
}


control '1-disconnect-cddrive' do
  title 'Disconnect unauthorized devices - CD/DVD Devices'
  impact 0.5
  desc '
  Any enabled or connected device represents a potential attack channel. Users and
  processes without privileges on a virtual machine can connect or disconnect hardware
  devices, such as network adapters and CD-ROM drives. Attackers can use this capability to
  breach virtual machine security. Removing unnecessary hardware devices can help prevent
  attacks.
  '
  describe powercli_command(cmd, conn_options) do
    its('exit_status') { should cmp 0 }
    its('stdout') { should cmp '' }
  end
end
