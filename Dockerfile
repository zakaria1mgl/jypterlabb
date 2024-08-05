# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables to non-interactive to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y curl iptables iptables-persistent lsb-release sudo

# Install OpenVPN repository key
RUN mkdir -p /etc/apt/keyrings && curl -fsSL https://packages.openvpn.net/packages-repo.gpg | tee /etc/apt/keyrings/openvpn.asc

# Add the OpenVPN repository
RUN echo "deb [signed-by=/etc/apt/keyrings/openvpn.asc] https://packages.openvpn.net/openvpn3/debian $(lsb_release -c -s) main" | tee /etc/apt/sources.list.d/openvpn-packages.list

# Update package lists and install OpenVPN Connector setup tool
RUN apt-get update && apt-get install -y python3-openvpn-connector-setup

# Enable IP forwarding
RUN sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
RUN sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
RUN sysctl -p

# Configure NAT
RUN IF=$(ip route | grep -m 1 default | awk '{print $5}') && iptables -t nat -A POSTROUTING -o $IF -j MASQUERADE
RUN IF=$(ip route | grep -m 1 default | awk '{print $5}') && ip6tables -t nat -A POSTROUTING -o $IF -j MASQUERADE

# Run openvpn-connector-setup
CMD ["sudo", "openvpn-connector-setup"]
