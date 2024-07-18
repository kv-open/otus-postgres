[postgres]
%{ for index, g in postgres_ipv4_address ~}
${postgres_hostname[index]} ansible_host=${postgres_ipv4_address[index]}
%{ endfor ~}


[wordpress]
%{ for index, g in wordpress_ipv4_address ~}
${wordpress_hostname[index]} ansible_host=${wordpress_ipv4_address[index]}
%{ endfor ~}


[zabbix]
%{ for index, g in zabbix_ipv4_address ~}
${zabbix_hostname[index]} ansible_host=${zabbix_ipv4_address[index]}
%{ endfor ~}

[elk]
%{ for index, g in elk_ipv4_address ~}
${elk_hostname[index]} ansible_host=${elk_ipv4_address[index]}
%{ endfor ~}


[jmeter]
%{ for index, g in jmeter_ipv4_address ~}
${jmeter_hostname[index]} ansible_host=${jmeter_ipv4_address[index]}
%{ endfor ~}


[all_vm:children]
postgres
wordpress
zabbix
elk

[all_vm:vars]
ansible_ssh_user=${host_user}
ansible_ssh_private_key_file=${ssh_key}
