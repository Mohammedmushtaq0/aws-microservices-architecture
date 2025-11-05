<h1><bold></bold>AWS Microservices Architecture using Terraform </h1>

  <h1>☁️ AWS Microservices Architecture using Terraform</h1>

  <h3>🧠 Overview</h3>
  <p>
    A <b>cloud-based microservices architecture for a website</b>, built on <b>AWS</b> using <b>Terraform</b> as Infrastructure as Code (IaC).<br>
    This project demonstrates how to design and deploy a <b>scalable, secure, and production-style AWS environment</b>,
    leveraging ECS, EC2, ALB, IAM, S3, CloudTrail, and related AWS services.
  </p>

  <hr>

  <h2>🏗️ Architecture Summary</h2>
  <p><b>Architecture Type:</b> AWS Microservices (ECS on EC2)<br>
     <b>Infrastructure Management:</b> Terraform<br>
     <b>Purpose:</b> Demonstration of scalable and modular cloud infrastructure for a website
  </p>

  <hr>

  <h2>🗺️ Architecture Diagram</h2>

  <pre>
[ User ]
   │
   ▼
[ Route 53 (DNS) ]
   │
   ▼
[ Application Load Balancer (ALB) ]
   │
   ▼
[ ECS Cluster (EC2 Launch Type) ]
   │        └── [ ECS Tasks (Docker Containers) ]
   │
   ▼
[ RDS / Database ]
   │
   ▼
[ S3 (Storage) ]
   │
   ▼
[ CloudTrail + CloudWatch (Monitoring & Logs) ]
  </pre>

  <ul>
    <li>ECS cluster runs Docker-based microservices on EC2 instances</li>
    <li>ALB distributes traffic evenly and performs health checks</li>
    <li>RDS stores application data (placeholder for integration)</li>
    <li>S3 serves as storage for static data, backups, or logs</li>
    <li>CloudTrail and CloudWatch enable auditing and performance monitoring</li>
  </ul>

  <hr>

  <h2>⚙️ Core Infrastructure Components</h2>

  <table border="1" cellspacing="0" cellpadding="5">
    <tr><th>Category</th><th>AWS Service</th><th>Purpose / Role</th><th>Status</th></tr>
    <tr><td>Compute</td><td>ECS (EC2 launch type)</td><td>Run containerized services</td><td>✅</td></tr>
    <tr><td></td><td>EC2 (Amazon Linux 2)</td><td>ECS container host instance</td><td>✅</td></tr>
    <tr><td></td><td>ECR</td><td>Container image registry for ECS tasks</td><td>✅</td></tr>
    <tr><td>Networking</td><td>VPC (custom)</td><td>Isolated and secure network environment</td><td>✅</td></tr>
    <tr><td></td><td>Subnets (public & private)</td><td>Separate application and data layers</td><td>✅</td></tr>
    <tr><td></td><td>Internet Gateway / NAT Gateway</td><td>Internet and outbound access for private subnets</td><td>✅</td></tr>
    <tr><td></td><td>Route Tables</td><td>Controls traffic routing between subnets</td><td>✅</td></tr>
    <tr><td>Load Balancing</td><td>Application Load Balancer (ALB)</td><td>Routes traffic to ECS tasks, performs health checks</td><td>✅</td></tr>
    <tr><td></td><td>Target Groups</td><td>Registers ECS task IPs via awsvpc mode</td><td>✅</td></tr>
    <tr><td>Storage & Data</td><td>S3</td><td>Static file storage, logs, or backups</td><td>⚙️ Basic setup</td></tr>
    <tr><td></td><td>RDS (MySQL/PostgreSQL)</td><td>Application database (created, not integrated)</td><td>⚙️ Basic</td></tr>
    <tr><td>Monitoring & Logging</td><td>CloudWatch</td><td>ECS metrics and logs</td><td>⚙️ Basic</td></tr>
    <tr><td></td><td>CloudTrail</td><td>API activity auditing for EC2 and ECS</td><td>✅ Added</td></tr>
    <tr><td>DNS & Enhancements</td><td>Route 53</td><td>DNS management, domain setup</td><td>⚙️ Added</td></tr>
    <tr><td>Security</td><td>IAM Roles & Policies</td><td>Role-based access for ECS, EC2, Terraform</td><td>✅</td></tr>
    <tr><td></td><td>Security Groups</td><td>Layer-4 firewall for ECS, ALB, RDS</td><td>✅</td></tr>
    <tr><td>Infrastructure Management</td><td>Terraform</td><td>Infrastructure as Code for reproducible setups</td><td>✅</td></tr>
  </table>

  <hr>

  <h2>🧰 Tools & Technologies</h2>

  <table border="1" cellspacing="0" cellpadding="5">
    <tr><th>Tool / Service</th><th>Purpose</th></tr>
    <tr><td>Terraform</td><td>Infrastructure provisioning and automation</td></tr>
    <tr><td>AWS CLI</td><td>Command-line management and verification</td></tr>
    <tr><td>Docker</td><td>Building and running container images</td></tr>
    <tr><td>Ubuntu (WSL)</td><td>Local development and SSH access</td></tr>
    <tr><td>CloudWatch Logs</td><td>ECS agent and service-level logging</td></tr>
    <tr><td>GitHub</td><td>Version control and project showcase</td></tr>
  </table>

  <hr>

  <h2>📁 Project Structure</h2>

  <pre>
scalable-infra/
└── infrafiles/
    ├── main.tf
    ├── ec2.tf
    ├── ecs.tf
    ├── ecr.tf
    ├── iam.tf
    ├── vpc.tf
    ├── ec2alb.tf
    ├── ec2alsg.tf
    ├── ec2mainserver.tf
    ├── s3storage.tf
    ├── databases.tf
    ├── cloudtrail.tf
    ├── monitoring-resources.tf
    ├── routeandrecords.tf
    ├── output.tf
    ├── note.txt
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    └── .terraform/
  </pre>

  <h3>File Descriptions:</h3>
  <ul>
    <li><code>vpc.tf</code> → Creates VPC, subnets, and route tables</li>
    <li><code>ecs.tf</code> / <code>ecr.tf</code> / <code>ec2.tf</code> → ECS cluster, image registry, and EC2 host configuration</li>
    <li><code>ec2alb.tf</code> / <code>ec2alsg.tf</code> → ALB setup and security group configuration</li>
    <li><code>iam.tf</code> → IAM roles and policies for ECS and EC2</li>
    <li><code>databases.tf</code> → RDS database setup (basic placeholder)</li>
    <li><code>cloudtrail.tf</code> → CloudTrail configuration for EC2 and ECS monitoring</li>
    <li><code>monitoring-resources.tf</code> → CloudWatch log group and metrics setup</li>
    <li><code>s3storage.tf</code> → S3 bucket for storing assets or logs</li>
    <li><code>routeandrecords.tf</code> → Route 53 record configuration</li>
    <li><code>main.tf</code> → Root configuration combining all modules</li>
    <li><code>output.tf</code> → Terraform output values</li>
  </ul>

  <hr>

  <h2>🚀 Deployment Steps</h2>

```
   
git clone https://github.com/Mohammedmushtaq0/aws-microservices-architecture.git
cd aws-microservices-architecture

terraform init
terraform validate
terraform plan
terraform apply
```

  <hr>

  <h2>📊 Monitoring & Logging</h2>
  <ul>
    <li><b>CloudWatch:</b> ECS agent logs and EC2 instance metrics</li>
    <li><b>CloudTrail:</b> Tracks API calls and ECS/EC2 activity</li>
    <li><b>S3 (optional):</b> Configured as CloudTrail log storage</li>
  </ul>

  <h2>🔐 Security & Access Control</h2>
  <ul>
    <li>IAM roles configured with least privilege principle</li>
    <li>Security groups for ECS, ALB, and RDS layers</li>
    <li>Private subnets for database isolation</li>
    <li>Optional SSM Parameter Store for secret management</li>
  </ul>

  <h2>🏁 Outcome</h2>
  <ul>
    <li>Terraform-based Infrastructure as Code</li>
    <li>ECS (EC2 launch type) with ALB and ECR integration</li>
    <li>Modular resource management across compute, network, and storage</li>
    <li>Real-world logging and monitoring with CloudTrail & CloudWatch</li>
  </ul>

  <h2>🧩 Future Enhancements</h2>
  <ul>
    <li>Integrate ECS tasks with RDS</li>
    <li>Add SSL certificates via AWS ACM and Route 53 records</li>
    <li>Implement CI/CD pipeline using CodePipeline and CodeBuild</li>
    <li>Add CloudWatch alarms and AWS Config for compliance tracking</li>
  </ul>

  <h2>🧾 Author</h2>
  <p>
    <b>Mohammed Mushtaq</b><br>
    Cloud Enthusiast | AWS Learner | Terraform Practitioner<br>
  </p>

  <hr>

  <p>⭐ If you found this project useful, don’t forget to star the repository!</p>

</body>
</html>
