[postgres_servers]
%{ for index, g in postgres_ipv4-address ~}
${postgres_name[index]} ansible_host=${postgres_ipv4-address[index]}
%{ endfor ~}


[otus_cluster:children]
postgres_servers

[otus_cluster:vars]
ansible_ssh_user=${host_user}
ansible_ssh_private_key_file=${ssh_key}
