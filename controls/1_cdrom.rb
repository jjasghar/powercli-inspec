# frozen_string_literal: true

viserver = attribute('viserver', default: 'vcenter.example.com', description: 'The server you want to connect to')
username = attribute('username', default: 'root', description: 'Username to connect as')
password = attribute('password', default: 'Cod3Can!', description: 'Password to connect with')
virtualmachine = attribute('virtualmachine', default: '*', description: 'Password to connect with')

cddrive_script = <<~EOH
  Connect-VIserver "#{viserver}" -User "#{username}" -Password "#{password}" | Out-Null
  get-vm "#{virtualmachine}" | Get-CDDrive | select connectionstate | convertto-json
EOH

cddrive_script_data = powershell(cddrive_script).stdout

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

  describe 'The CDDrive connected setting' do
    it 'should be not set to true' do
      expect(cddrive_script_data).not_to match(/Connected.*\strue\s/)
    end
  end
end
