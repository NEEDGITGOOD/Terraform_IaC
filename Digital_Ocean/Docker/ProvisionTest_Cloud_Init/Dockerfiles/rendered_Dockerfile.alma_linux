# Use AlmaLinux as the base image
FROM almalinux:latest

# Install OpenSSH
RUN yum -y install openssh-server passwd && \
    yum clean all

# Setup User
ARG USER_PASSWORD
RUN useradd ssh_user && \
    echo "${USER_PASSWORD}" | passwd ssh_user --stdin  

# Configure SSH for password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Generate host keys
RUN ssh-keygen -A

# Expose the SSH port
EXPOSE 22

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]
