# PERFORCE-OCI


![GitHub](https://img.shields.io/github/license/JarnotMaciej/perforce-oci?style=flat-square) ![GitHub](https://img.shields.io/github/languages/top/JarnotMaciej/perforce-oci?style=flat-square) ![GitHub](https://img.shields.io/github/languages/code-size/JarnotMaciej/perforce-oci?style=flat-square) 

OCI Image for Quick Game Development

# SHORT DESCRIPTION
This project provides an OCI (Open Container Initiative) image for setting up a Perforce Helix Core server, tailored for quick game development environments. It includes automated setup scripts and configurations to streamline the deployment process of a Perforce version control system.

# INSTALLATION
- Ensure Docker is installed on your system
- Clone the repository containing the project files
- Navigate to the project directory
- Pull the image and run:
  ```
    docker run -it -p 1666:1666 --name perforce-container ghcr.io/jarnotmaciej/perforce-oci:main
  ```

- Or build the Docker image:
  ```
  docker build -t perforce-game-dev .
  ```
- And then run the container:
  ```
  docker run -d -p 1666:1666 --name perforce-server perforce-game-dev
  ```

# USAGE INSTRUCTION
- Access the Perforce server using the following credentials:
  - P4PORT: ssl:127.0.0.1:1666
  - P4USER: super
- Connect to the server using Perforce command-line tools or P4V (Perforce Visual Client)
- The server is pre-configured with optimized settings for game development:
  - Server refresh rate is set to 10 seconds
  - Full istats are disabled for improved performance
  - Reconnect interval is set to 300 seconds
  - Automatic update checks are disabled
  - HTML tools are turned off
  - Data analytics prompt is disabled
- To customize server settings, modify the configure_p4.sh script before building the image
- For security reasons, it's recommended to change the default superuser password after first login
