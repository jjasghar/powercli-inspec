# frozen_string_literal: true

viserver = attribute('viserver', default: 'vcenter.example.com', description: 'The server you want to connect to')
username = attribute('username', default: 'root', description: 'Username to connect as')
password = attribute('password', default: 'Cod3Can!', description: 'Password to connect with')
virtualmachine = attribute('virtualmachine', default: '*', description: 'Password to connect with')

disable_ssh_script = <<~EOH
  Connect-VIserver "#{viserver}" -User "#{username}" -Password "#{password}" | Out-Null
  Get-VMhost | Get-VMHostService | Where {$_.key -eq "TSM-SSH" } | Select Running | Convertto-JSON
EOH

disable_ssh_script_data = powershell(disable_ssh_script).stdout

control '2-disable-ssh' do
  title 'Disable SSH'
  impact 0.5
  desc '
  Disable Secure Shell (SSH) for each ESXi host to prevent remote access to the ESXi shell.
  only enable if needed for troubleshooting or diagnostics.
  '

  describe 'Disable SSH shell' do
    it 'should not have the process TSM-SSH running' do
      expect(disable_ssh_script_data).to_not eq("{\r\n    \"Running\":  true\r\n}\r\n")
    end
  end
end
