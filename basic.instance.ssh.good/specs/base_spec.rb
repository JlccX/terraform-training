
    describe package('python') do
        it { should be_installed }
    end

    control "Verifying index.html file" do
        impact 1.0
        title "Verifying index.html file title"
        desc "The html page should contain the words 'Hello, world'"
        describe file('/home/ubuntu/index.html') do
            it { should exist }
            its('content') { should match "Hello, world" }
            #it { should be_readable }
        end
    end

    control 'verify-index.html' do
        title 'hello-world'
        desc "Verifying the index.html page content."
        describe command('cat /home/ubuntu/index.html') do
            its('exit_status') { should eq 0 }
            its('stdout') { should cmp /Hello, world/ }
        end
    end

    # control 'verify server app' do
    #     title 'server app'
    #     desc "Verifying required server app."
    #     describe command('python --version') do
    #         its('exit_status') { should eq 0 }
    #         its('stdout') { should include 'Python'  }
    #     end
    # end

    # describe command('python --version') do
    #     #its('exit_status') { should eq 0 }
    #     its('stdout') { should include 'Python'  }
    # end

    

    # Disallow insecure protocols by testing

    describe package('telnetd') do
        #command('uname -a').stdout
        it { should_not be_installed }
    end
  
    describe inetd_conf do
        its("telnet") { should eq nil }
    end

    # describe file('/proc/cpuinfo') do
    #     its('cpu cores') { should be > 0 }
    # end

    # describe file('/proc/cpuinfo') do
    #     its('model') { should_not eq nil }
    # end

    
    # The ssh protocol should be enabled
    describe sshd_config do
        its('Protocol'){ should eq '2' }
    end