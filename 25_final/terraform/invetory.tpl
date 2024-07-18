[postgres]
%{ for index, g in wordpress_db_ipv4-address ~}
${wordpress_db_name[index]} ansible_host=${wordpress_db_ipv4-address[index]}
%{ endfor ~}


[wordpress]
%{ for index, g in wordpress_ipv4-address ~}
${wordpress_name[index]} ansible_host=${wordpress_ipv4-address[index]}
%{ endfor ~}


[zabbix]
%{ for index, g in zabbix_ipv4-address ~}
${zabbix_name[index]} ansible_host=${zabbix_ipv4-address[index]}
%{ endfor ~}

[elk]
%{ for index, g in elk_ipv4-address ~}
${elk_name[index]} ansible_host=${elk_ipv4-address[index]}
%{ endfor ~}


[jmeter]
%{ for index, g in jmeter_ipv4-address ~}
${jmeter_name[index]} ansible_host=${jmeter_ipv4-address[index]}
%{ endfor ~}


[all_vm:children]
postgres
wordpress
zabbix
elk

[all_vm:vars]
ansible_ssh_user=${host_user}
ansible_ssh_private_key_file=${ssh_key}
