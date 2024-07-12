# Creating Recommended Alerts for Amazon OpenSearch Service with Terraform



## Introduction

With the right monitoring tools, you can proactively identify potential issues before they impact your users. This article explores how to monitor Amazon OpenSearch Service using CloudWatch metrics and alerts, which offer powerful capabilities for tracking and maintaining the health and performance of your search and analytics workloads.

Amazon OpenSearch Service excels in search, log analytics, and RAG systems. It supports features like Multi-AZ deployments, standby instances, and automated snapshots, enhancing its reliability and resilience for critical applications.

Effective monitoring of Amazon OpenSearch Service is crucial for maintaining performance and availability. Utilizing CloudWatch metrics and alerts allows you to promptly identify and address potential issues, ensuring a seamless experience for your users.

## Prerequisites

- **Knowledge of Terraform and OpenSearch:** Basic understanding of Terraform’s infrastructure-as-code approach and familiarity with Amazon OpenSearch Service.
- **AWS Account:** An active AWS account to deploy and manage OpenSearch Service.
- **Amazon OpenSearch Service Cluster:** A running Amazon OpenSearch managed cluster
- **Tools Required:**
  - **Terraform:** Installed on your local machine or in the CI/CD pipeline.
  - **AWS CLI:** Configured with your AWS credentials to interact with AWS services.

## **Metrics and alerts for Amazon OpenSearch service**

Amazon OpenSearch Service generates various metrics that help estimate and forecast cluster performance, monitor current load, and make informed decisions for cluster adjustments.

Access these metrics in the AWS console via CloudWatch: **CloudWatch -> Metrics -> All Metrics -> ES/OpenSearch Metrics**. An automated dashboard allows you to track the evolution of different metrics over time.

To receive notifications about potential issues, use alerts. Alerts are crucial for detecting and responding to problems in your OpenSearch cluster, such as:

- **Node Failures:** Identify when a node goes down, affecting cluster performance and data availability.
  *Example:* NodesMinimum alert notifies if any node has been unreachable for one day.
- **Indexing Issues:** Detect slow or failing indexing, impacting search performance and data freshness.
  *Example:* ThreadpoolWriteQueue and ClusterIndexWritesBlocked alerts notify when indexing requests are blocked or queued excessively.

- **Query Performance:** Monitor query latency and throughput to ensure optimal search performance.
  *Example:* ThreadpoolSearchQueueAverage and 5xxErrors alerts notify when query concurrency is high or query failures occur frequently.

- **Storage Capacity:** Alert when storage capacity is approaching limits, preventing data loss and ensuring cluster stability.
  *Example:* FreeStorageSpace alert notifies when a node’s free storage space is critically low.

- **Cluster Health:** Monitor the overall health status of the cluster.
  *Example:* ClusterStatusRed and ClusterStatusYellow alerts notify when primary shards or replica shards are not allocated to nodes.

- **JVM Memory Pressure:** Detect high JVM memory usage, which could lead to out-of-memory errors.
  *Example:* JVMMemoryPressure and OldGenJVMMemoryPressure alerts notify when JVM memory pressure is critically high.

- **Snapshot Failures:** Identify issues with automated snapshots, crucial for data backup and recovery.
  *Example:* AutomatedSnapshotFailure alert notifies if an automated snapshot fails.

- **Anomaly Detection and Plugins Health:** Monitor the health of various plugins and anomaly detection features.
  *Example:* ADPluginUnhealthy and SQLUnhealthy alerts notify if the anomaly detection or SQL plugins are not functioning correctly.

Recommended alerts for Amazon OpenSearch Service can be found here:

- [Amazon OpenSearch Service CloudWatch Alarms](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cloudwatch-alarms.html)

We provide Terraform code that creates all recommended alerts listed in the AWS documentation. You do not need to set up all alerts for your cluster if you do not use plugins, UltraWarm, or master nodes. Review the descriptions and comment out unneeded alarms. You can uncomment required alarms anytime if you use these extra features in the future.

The additional cost for alarm metrics is about $0.10 per month per metric.

## **Conclusion**

In this blog post, we've demonstrated how to create recommended alerts for Amazon OpenSearch Service using Terraform. By monitoring and alerting on these key metrics, you can ensure the reliability, performance, and scalability of your OpenSearch cluster. Remember to customize the alerts to fit your specific use case and environment.