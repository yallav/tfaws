[servers]
%{for server in servers ~}
${server}
%{endfor ~}