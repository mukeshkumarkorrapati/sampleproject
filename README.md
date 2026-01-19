# DEVOPS Jenkins CICD project

This project automates code build, test, security scan, and container deployment using Jenkins, Maven, SonarQube, Trivy, and Docker for a streamlined CI/CD workflow.

<img width="903" height="211" alt="image" src="https://github.com/user-attachments/assets/5010e83b-0686-448e-a732-0b8ed28cccdd" />



<img width="940" height="95" alt="image" src="https://github.com/user-attachments/assets/eb940a02-949f-4da7-b583-748af4c73ecf" />


--------------------------------------------------------------------------------------------------------------------------------------------------

# Jenkins and SonarQube End-to-End Setup Guide 

# Jenkins Installation on Ubuntu

**Prerequisites**

* Ubuntu server (20.04 or later recommended)

* Sudo privileges

**Steps**

1. Update system packages

        sudo apt update && sudo apt upgrade -y

2. Install Java (required for Jenkins)

        sudo apt install openjdk-11-jdk -y
        java -version

3. Add Jenkins repository and key

        sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
           
        echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]"   https://pkg.jenkins.io/debian-stable binary/ | sudo tee   /etc/apt/sources.list.d/jenkins.list > /dev/null


5. Install Jenkins

        sudo apt update
        sudo apt install jenkins -y

6. Start and enable Jenkins service

       sudo systemctl start jenkins
       sudo systemctl enable jenkins
       sudo systemctl status jenkins

7. Open firewall port 8080

        sudo ufw allow 8080

**Access Jenkins Web UI**

URL: http://Jenkins-Public-IP:8080

Retrieve initial admin password:

       sudo cat /var/lib/jenkins/secrets/**initialAdminPassword**


**Reference**
https://www.jenkins.io/doc/book/installing/linux/

-----------------------------------------------------------------------------------------------------------------------------------------------------

 # Install Trivy via Official apt Repository

**Steps**

1. Install prerequisites:

       sudo apt install wget apt-transport-https gnupg lsb-release -y

2. Add Trivy GPG key and repository

       wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
       
       echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list

4. Update and install Trivy

       sudo apt update
       sudo apt install trivy -y

5. Verify installation

       trivy --version

**Reference**

https://trivy.dev/docs/latest/getting-started/installation/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

 
 # SonarQube Server Setup

**Prerequisites**

* Docker installed on Ubuntu

* At least 2GB RAM available

**Steps**

1. Install Docker

      sudo apt update
      sudo apt install docker.io -y
      sudo systemctl enable docker
      sudo systemctl start docker

2. Start the SonarQube application in Sonar container 

          docker run -d --name sonarqube \
            -p 9000:9000 \
            --restart unless-stopped \
            sonarqube:lts

**Access SonarQube Web UI**

URL: http://Sonar-Public-IP:9000

**Default credentials:**

Username: admin

Password: admin

**(Optional) Run with PostgreSQL for production:**
    
      docker run -d --name postgres \
        -e POSTGRES_USER=sonar \
        -e POSTGRES_PASSWORD=sonar \
        -e POSTGRES_DB=sonar \
        postgres:13

      docker run -d --name sonarqube \
        -p 9000:9000 \
        -e SONARQUBE_JDBC_URL=jdbc:postgresql://postgres:5432/sonar \
        -e SONARQUBE_JDBC_USERNAME=sonar \
        -e SONARQUBE_JDBC_PASSWORD=sonar \
        --link postgres \
        sonarqube:lts
----------------------------------------------------------------------------------------------------------------------------------------------
# End to End Jenkins CICD Pipeline setup 

**Prequisites: **
I1. nstall below plugins to jenkins.

**Plugins:**
* Eclipse Temurin Installer → to provision JDKs like Java 17
* Pipeline Maven Integration → to run Maven builds cleanly in pipelines
* SonarQube Scanner → to run code analysis
* Sonar Quality Gate → to enforce quality gate checks in Jenkins
* Docker → to provision Docker agents if needed
* Docker Pipeline → to build, tag, and push Docker images inside pipelines

2. Configure below Tools to jenkins

**Tools**
* Marven(marven3)
* JDK(jdk-17)
* Docker(latest)
* SonarQube(7.3.0)


<img width="574" height="325" alt="image" src="https://github.com/user-attachments/assets/b02ffa5f-c4f2-42f4-a6f7-bd7e342b995b" />


3. Global Credentials Setup:
   * docker-cred(Type: Username with password) → Used by withDockerRegistry to log in to Docker Hub
   * sonarqube(Type: Secret text) → Used by waitForQualityGate and withSonarQubeEnv to authenticate Jenkins with SonarQube.
   * git-cred(Type: Username with password)  → Used by the git step in your pipeline to clone private repositories.

4. Configure SonarQube Server in Jenkins. **Manage Jenkins → Configure System → SonarQube servers**
   

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/55a276fc-e873-4e26-bc79-d86b936bfc97" />

 **Create Jenkin Pipeline Project with Source code https://github.com/mukeshjava92/Boardgame.git and run the job**.

 <img width="940" height="298" alt="image" src="https://github.com/user-attachments/assets/ead878a0-8dc8-4453-82f4-3f473e84783f" />

**static code analysis results on SonarQube**

 <img width="940" height="357" alt="image" src="https://github.com/user-attachments/assets/a407c41f-1c48-416b-b004-892d7196437f" />
 
**Application is deployed and accessible**

 <img width="940" height="500" alt="image" src="https://github.com/user-attachments/assets/815765df-bc2f-4b66-9ea6-de4cc83411c4" />






