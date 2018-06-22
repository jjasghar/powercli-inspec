class PowerCLICommand < Inspec.resource(1)
  name 'powercli_command'

  desc 'Run PowerCLI commands via InSpec'

  example <<~EOX
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
  EOX

  attr_reader :stdout, :stderr, :exit_status

  def initialize(cmd = '', conn_options = {})

    @cmd = cmd
    raise Inspec::Exceptions::ResourceFailed, 'Please update InSpec to newer than 2.1.43. Details: https://git.io/vhCNK' unless Inspec::VERSION >= '2.1.43'
    raise Inspec::Exceptions::ResourceFailed, 'Please specify VIserver.' if conn_options[:viserver].nil?
    raise Inspec::Exceptions::ResourceFailed, 'Please specify username.' if conn_options[:username].nil?
    raise Inspec::Exceptions::ResourceFailed, 'Please specify password.' if conn_options[:password].nil?
    if run_command('',conn_options).exit_status != 0
      raise Inspec::Exceptions::ResourceFailed, 'Could not connect to remote VIServer is PowerCLI installed? Details: https://code.vmware.com/web/dp/tool/vmware-powercli/'
    end

    output = run_command(cmd, conn_options)

    @stdout = output.stdout
    @stderr = output.stderr
    @exit_status = output.exit_status
  end

  def to_s
    "powercli_command: #{@cmd}"
  end

  def run_command(command, conn_options)
    viserver = conn_options[:viserver]
    username = conn_options[:username]
    password = conn_options[:password]

    connect_command = "Connect-VIserver #{viserver} -User #{username} -Password #{password} | Out-Null;"
    inspec.powershell(connect_command + command)
  end
end
