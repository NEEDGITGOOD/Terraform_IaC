# Use Kali Linux as the base image
FROM kalilinux/kali-rolling

# Install OpenSSH
RUN apt-get update && apt-get install -y openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Create the necessary directory for SSH
RUN mkdir -p /run/sshd

# Setup User
ARG USER_PASSWORD
RUN useradd -m ssh_user && \
    echo "ssh_user:${USER_PASSWORD}" | chpasswd

# Configure SSH for password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Generate host keys
RUN ssh-keygen -A

# Expose the SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]