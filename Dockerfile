# Use Ubuntu Jammy as the base image
FROM ubuntu:jammy

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

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
ENV P4PORT=ssl:1666
ENV P4USER=super

# Create volume mount point for persistent data
VOLUME ["/opt/perforce/servers"]

# Copy a script to run configuration commands
COPY configure_p4.sh /root/configure_p4.sh
RUN chmod +x /root/configure_p4.sh

# Expose the Perforce port
EXPOSE 1666

# Copy the entrypoint script
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Set the entrypoint to run the Perforce server and configuration
ENTRYPOINT ["/root/entrypoint.sh"]

# Instructions to build and run:
# Build: docker build -t perforce-helix .
# Run: docker run -d -p 1666:1666 --name perforce-container perforce-helix
