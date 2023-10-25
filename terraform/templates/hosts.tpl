[servers]
%{for web_server in web_servers ~}
${web_server}
%{endfor ~}