# Use Ubuntu Jammy as the base image
FROM ubuntu:jammy

# Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    sudo \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Copy the setup script
COPY p4setup.sh /root/p4setup.sh

# Make the script executable
RUN chmod +x /root/p4setup.sh

# Run the setup script
RUN /root/p4setup.sh

# Install Helix P4D
RUN apt-get update && apt-get install -y helix-p4d

# Set environment variables
ENV P4PORT=ssl:127.0.0.1:1666
ENV P4USER=super

# Copy a script to run configuration commands
COPY configure_p4.sh /root/configure_p4.sh
RUN chmod +x /root/configure_p4.sh

# Expose the Perforce port
EXPOSE 1666

# Set the entrypoint to run the Perforce server and configuration
ENTRYPOINT ["/bin/bash", "-c", "/opt/perforce/sbin/configure-helix-p4d.sh copybara && /root/configure_p4.sh && tail -f /dev/null"]

# Instructions to build and run:
# Build: docker build -t perforce-helix .
# Run: docker run -d -p 1666:1666 --name perforce-container perforce-helix
