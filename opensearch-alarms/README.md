# Creating Recommended Alerts for Amazon OpenSearch Service with Terraform

## Introduction

With the right monitoring tools, you can proactively identify potential issues before they impact your users. This article explores how to monitor Amazon OpenSearch Service using CloudWatch metrics and alerts, which offer powerful capabilities for tracking and maintaining the health and performance of your search and analytics workloads.

Amazon OpenSearch Service excels in search, log analytics, and RAG systems. It supports features like Multi-AZ deployments, standby instances, and automated snapshots, enhancing its reliability and resilience for critical applications.

Effective monitoring of Amazon OpenSearch Service is crucial for maintaining performance and availability. Utilizing CloudWatch metrics and alerts allows you to promptly identify and address potential issues, ensuring a seamless experience for your users.

## Installation

Here are the instructions to initialize, plan, and apply a Terraform configuration:

1. **Install Terraform**:

   - Download Terraform from the [official website](https://www.terraform.io/downloads.html) for your operating system.
- Follow the instructions to install it:
	  - For Windows: Unzip the downloaded file and add the terraform.exe to your system’s PATH.
  - For macOS: Use Homebrew with the command brew install terraform.
     - For Linux: Unzip the downloaded file and move the terraform binary to /usr/local/bin/.

2. **Navigate to the Directory**:

   - Open your terminal and change to the directory containing your Terraform configuration file

3. **Initialize Terraform**:

   - Open your terminal and navigate to the directory containing your Terraform configuration files.
   - Run the following command to initialize your Terraform working directory. This will download the necessary provider plugins and set up the backend:
     ```sh
     terraform init
     ```

4. **Plan the Terraform Deployment**:
   - After initialization, run the following command to create an execution plan. This command shows you what actions Terraform will take to achieve the desired state defined in your configuration files:
     ```sh
     terraform plan
     ```
   - Review the output to ensure that the proposed changes are what you expect.

5. **Apply the Terraform Plan**:
   - If the plan looks good, you can apply it by running the following command. This will make the actual changes to your infrastructure:
     ```sh
     terraform apply
     ```
   - Terraform will ask for confirmation before applying the changes. Type `yes` to proceed.

These commands will set up your Terraform environment, plan your infrastructure changes, and apply those changes to your cloud provider.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.9.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.58.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.58.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.ad_plugin_unhealthy_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.alerting_degraded_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.asynchronous_search_failure_rate_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.asynchronous_search_store_health_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.automated_snapshot_failure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cluster_index_writes_blocked](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cluster_status_red](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cluster_status_yellow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_utilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.errors_5xx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.free_storage_space](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.hot_to_warm_migration_failure_count_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.hot_to_warm_migration_queue_size_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.hot_to_warm_migration_success_latency_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.jvm_memory_pressure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.kms_key_error](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.kms_key_inaccessible](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ltr_status_red_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.master_cpu_utilization_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.master_jvm_memory_pressure_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.master_old_gen_jvm_memory_pressure_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.master_reachable_from_node_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.nodes_minimum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.old_gen_jvm_memory_pressure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.opensearch_active_shards_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.sql_unhealthy_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.threadpool_search_queue_average](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.threadpool_search_queue_maximum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.threadpool_search_rejected_increase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.threadpool_write_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.threadpool_write_rejected_increase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.warm_cpu_utilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.warm_free_storage_space_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.warm_jvm_memory_pressure_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.warm_old_gen_jvm_memory_pressure_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.warm_to_cold_migration_failure_count_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.warm_to_cold_migration_latency_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.warm_to_cold_migration_queue_size_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sns_topic.alarms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.email_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarms_email"></a> [alarms\_email](#input\_alarms\_email) | An e-mail address for the alarms for the OpenSearch cluster | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain name of the OpenSearch cluster, which should be in lowercase | `string` | `"trc-workshop"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The count of instances to be deployed | `number` | `1` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where the resources will be deployed | `string` | `"eu-central-1"` | no |

