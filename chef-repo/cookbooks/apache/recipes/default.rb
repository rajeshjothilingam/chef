#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe "php::default"

package "httpd" do
	action :install
end

service "httpd" do
	action [:enable, :start]
end

node["apache"]["sites"].each do |sitename, data|
	document_root = "/content/sites/#{sitename}"
	
	directory document_root do
		mode "0755"
		recursive true
	end

	template "/etc/httpd/conf.d/#{sitename}.conf" do
        	source "vhost.erb"
        	mode "0644"
        	variables(
                	:document_root => document_root,
                	:port => data["port"],
                	:domain => data["domain"]
        	)
        	notifies :restart, "service[httpd]"
	end

	template "/content/sites/#{sitename}/index.html" do
		source "index.html.erb"
		mode "0644"
		variables(
			:site_title => data["site_title"],
			:comingsoon => "coming soon"
		)
	end


end

