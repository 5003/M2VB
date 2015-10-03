Vagrant.configure(2) do |c|
  c.vm.box =                        ENV["BOX_NAME"]
  c.vm.box_url =                    ENV["BOX_URL"]
  c.vm.box_check_update = false
  c.vm.box_download_checksum =      ENV["BOX_HEX"]
  c.vm.box_download_checksum_type = ENV["BOX_HASH"]
  c.vm.provision "shell", path: "compact.sh"
end