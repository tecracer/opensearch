
########################################################################################################
# Create a SNS topic
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic
########################################################################################################

# Create an SNS topic
resource "aws_sns_topic" "alarms" {
  name = "${var.domain}-alarms-topic"
}

# Subscribe an email address to the SNS topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.alarms_email
}

########################################################################################################
# Define the CloudWatch alarms
# https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cloudwatch-alarms.html
########################################################################################################

# Alarm: ClusterStatus.red maximum is >= 1 for 1 minute, 1 consecutive time	
# Issue: At least one primary shard and its replicas are not allocated to a node. 

resource "aws_cloudwatch_metric_alarm" "cluster_status_red" {
  alarm_name          = "ClusterStatusRed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ClusterStatus.red"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Cluster status is red"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: ClusterStatus.yellow maximum is >= 1 for 1 minute, 5 consecutive times
# Issue: At least one replica shard is not allocated to a node. 

resource "aws_cloudwatch_metric_alarm" "cluster_status_yellow" {
  alarm_name          = "ClusterStatusYellow"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ClusterStatus.yellow"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Cluster status is yellow"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: FreeStorageSpace minimum is <= 20480 for 1 minute, 1 consecutive time
# Issue: A node in your cluster is down to 20 GiB of free storage space. See Lack of available storage space. This value is in MiB, so rather than 20480, we recommend setting it to 25% of the storage space for each node.


resource "aws_cloudwatch_metric_alarm" "free_storage_space" {
  alarm_name          = "FreeStorageSpace"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "20480"
  alarm_description   = "Free storage space is low"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: ClusterIndexWritesBlocked is >= 1 for 5 minutes, 1 consecutive time
# Issue: Your cluster is blocking write requests. 

resource "aws_cloudwatch_metric_alarm" "cluster_index_writes_blocked" {
  alarm_name          = "ClusterIndexWritesBlocked"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ClusterIndexWritesBlocked"
  namespace           = "AWS/ES"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Cluster is blocking write requests"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: Nodes minimum is < x for 1 day, 1 consecutive time
# Issue: x is the number of nodes in your cluster. This alarm indicates that at least one node in your cluster has been unreachable for one day. 

resource "aws_cloudwatch_metric_alarm" "nodes_minimum" {
  alarm_name          = "NodesMinimum"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Nodes"
  namespace           = "AWS/ES"
  period              = "86400"
  statistic           = "Minimum"
  threshold           = var.instance_count
  alarm_description   = "At least one node in the cluster has been unreachable for one day"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: AutomatedSnapshotFailure maximum is >= 1 for 1 minute, 1 consecutive tim
# Issue: An automated snapshot failed. This failure is often the result of a red cluster health status. See Red cluster status.
# For a summary of all automated snapshots and some information about failures, try one of the following requests:
# GET domain_endpoint/_snapshot/cs-automated/_all
# GET domain_endpoint/_snapshot/cs-automated-enc/_all

resource "aws_cloudwatch_metric_alarm" "automated_snapshot_failure" {
  alarm_name          = "AutomatedSnapshotFailure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "AutomatedSnapshotFailure"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "An automated snapshot failed"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: CPUUtilization or WarmCPUUtilization maximum is >= 80% for 15 minutes, 3 consecutive times
# Issue: 100% CPU utilization might occur sometimes, but sustained high usage is problematic. Consider using larger instance types or adding instances.

resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ES"
  period              = "900"
  statistic           = "Maximum"
  threshold           = "80"
  alarm_description   = "Sustained high CPU utilization"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "warm_cpu_utilization" {
  alarm_name          = "WarmCPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "WarmCPUUtilization"
  namespace           = "AWS/ES"
  period              = "900"
  statistic           = "Maximum"
  threshold           = "80"
  alarm_description   = "Sustained high CPU utilization on warm nodes"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}


# Alarm: JVMMemoryPressure maximum is >= 95% for 1 minute, 3 consecutive times. 
# Issue: The cluster could encounter out of memory errors if usage increases. Consider scaling vertically. OpenSearch Service uses half of an instance's RAM for the Java heap, up to a heap size of 32 GiB. You can scale instances vertically up to 64 GiB of RAM, at which point you can scale horizontally by adding instances.
resource "aws_cloudwatch_metric_alarm" "jvm_memory_pressure" {
  alarm_name          = "JVMMemoryPressure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "JVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "95"
  alarm_description   = "High JVM memory pressure"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}
# Alarm: OldGenJVMMemoryPressure maximum is >= 80% for 1 minute, 3 consecutive times
# Issue: The cluster could encounter out of memory errors if usage increases. Consider scaling vertically. OpenSearch Service uses half of an instance's RAM for the Java heap, up to a heap size of 32 GiB. You can scale instances vertically up to 64 GiB of RAM, at which point you can scale horizontally by adding instances.
resource "aws_cloudwatch_metric_alarm" "old_gen_jvm_memory_pressure" {
  alarm_name          = "OldGenJVMMemoryPressure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "OldGenJVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"
  alarm_description   = "High old generation JVM memory pressure"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}


# Alarm: MasterCPUUtilization maximum is >= 50% for 15 minutes, 3 consecutive times
# Issue: Consider using larger instance types for your dedicated master nodes. Because of their role in cluster stability and blue/green deployments, dedicated master nodes should have lower CPU usage than data nodes.
resource "aws_cloudwatch_metric_alarm" "master_cpu_utilization_alarm" {
  alarm_name          = "MasterCPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "MasterCPUUtilization"
  namespace           = "AWS/ES"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "50"
  alarm_description   = "Master node CPU utilization is high. Consider using larger instance types for dedicated master nodes."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: MasterJVMMemoryPressure maximum is >= 95% for 1 minute, 3 consecutive times
# Issue: Consider using larger instance types for your dedicated master nodes. Because of their role in cluster stability and blue/green deployments, dedicated master nodes should have lower CPU usage than data nodes.

resource "aws_cloudwatch_metric_alarm" "master_jvm_memory_pressure_alarm" {
  alarm_name          = "MasterJVMMemoryPressure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "MasterJVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "95"
  alarm_description   = "Master node JVM memory pressure is high. Consider using larger instance types for dedicated master nodes."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}
# Alarm: MasterOldGenJVMMemoryPressure maximum is >= 80% for 1 minute, 3 consecutive times
# Issue: Consider using larger instance types for your dedicated master nodes. Because of their role in cluster stability and blue/green deployments, dedicated master nodes should have lower CPU usage than data nodes.

resource "aws_cloudwatch_metric_alarm" "master_old_gen_jvm_memory_pressure_alarm" {
  alarm_name          = "MasterOldGenJVMMemoryPressure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "MasterOldGenJVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"
  alarm_description   = "OpenSearch master node old generation JVM memory pressure is high. Consider using larger instance types for dedicated master nodes."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: KMSKeyError is >= 1 for 1 minute, 1 consecutive time
# Issue: The AWS KMS encryption key that is used to encrypt data at rest in your domain is disabled. Re-enable it to restore normal operations. For more information, see Encryption of data at rest for Amazon OpenSearch Service.

resource "aws_cloudwatch_metric_alarm" "kms_key_error" {
  alarm_name          = "KMSKeyError"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "KMSKeyError"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "KMS encryption key is disabled"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: KMSKeyInaccessible is >= 1 for 1 minute, 1 consecutive time
# Issue: The AWS KMS encryption key that is used to encrypt data at rest in your domain has been deleted or has revoked its grants to OpenSearch Service. You can't recover domains that are in this state. However, if you have a manual snapshot, you can use it to migrate to a new domain. To learn more, see Encryption of data at rest for Amazon OpenSearch Service.

resource "aws_cloudwatch_metric_alarm" "kms_key_inaccessible" {
  alarm_name          = "KMSKeyInaccessible"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "KMSKeyInaccessible"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "KMS encryption key is inaccessible"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: shards.active is >= 30000 for 1 minute, 1 consecutive time
# Issue: The total number of active primary and replica shards is greater than 30,000. You might be rotating your indexes too frequently. Consider using ISM to remove indexes once they reach a specific age.

resource "aws_cloudwatch_metric_alarm" "opensearch_active_shards_alarm" {
  alarm_name          = "ActiveShards"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "shards.active"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "30000"
  alarm_description   = "The total number of active primary and replica shards is greater than 30,000. Consider using ISM to remove indexes once they reach a specific age."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}
# Alarm: 5xx alarms >= 10% of OpenSearchRequests
# Issue: One or more data nodes might be overloaded, or requests are failing to complete within the idle timeout period. Consider switching to larger instance types or adding more nodes to the cluster. Confirm that you're following best practices for shard and cluster architecture.

resource "aws_cloudwatch_metric_alarm" "errors_5xx" {
  alarm_name          = "5xxErrors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = "10"
  alarm_description   = "5xx errors are greater than or equal to 10% of OpenSearch requests"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  treat_missing_data  = "ignore"
  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "5xx Error Percentage"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "OpenSearchRequests"
      namespace   = "AWS/ES"
      period      = "60"
      stat        = "Sum"

      dimensions = {
        DomainName = var.domain
        ClientId   = data.aws_caller_identity.current.account_id
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "5xx"
      namespace   = "AWS/ES"
      period      = "60"
      stat        = "Sum"

      dimensions = {
        DomainName = var.domain
        ClientId   = data.aws_caller_identity.current.account_id
      }
    }
  }
}


# Alarm: MasterReachableFromNode maximum is < 1 for 5 minutes, 1 consecutive time
# Issue: This alarm indicates that the master node stopped or is unreachable. These failures are usually the result of a network connectivity issue or an AWS dependency problem.

resource "aws_cloudwatch_metric_alarm" "master_reachable_from_node_alarm" {
  alarm_name          = "MasterReachableFromNode"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "MasterReachableFromNode"
  namespace           = "AWS/ES"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "The master node stopped or is unreachable. These failures are usually the result of a network connectivity issue or an AWS dependency problem."
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: ThreadpoolWriteQueue average is >= 100 for 1 minute, 1 consecutive time
# Issue: The cluster is experiencing high indexing concurrency. Review and control indexing requests, or increase cluster resources.

resource "aws_cloudwatch_metric_alarm" "threadpool_write_queue" {
  alarm_name          = "ThreadpoolWriteQueue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ThreadpoolWriteQueue"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Average"
  threshold           = "100"
  alarm_description   = "Threadpool write queue is high"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: ThreadpoolSearchQueue average is >= 500 for 1 minute, 1 consecutive time
# Issue: The cluster is experiencing high search concurrency. Consider scaling your cluster. You can also increase the search queue size, but increasing it excessively can cause out of memory errors.

resource "aws_cloudwatch_metric_alarm" "threadpool_search_queue_average" {
  alarm_name          = "ThreadpoolSearchQueueAverage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ThreadpoolSearchQueue"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "Threadpool search queue average is high"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}
# Alarm: ThreadpoolSearchQueue maximum is >= 5000 for 1 minute, 1 consecutive time
# Issue: The cluster is experiencing high search concurrency. Consider scaling your cluster. You can also increase the search queue size, but increasing it excessively can cause out of memory errors.

resource "aws_cloudwatch_metric_alarm" "threadpool_search_queue_maximum" {
  alarm_name          = "ThreadpoolSearchQueueMaximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ThreadpoolSearchQueue"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "5000"
  alarm_description   = "Threadpool search queue maximum is high"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}
# Alarm: Increase in ThreadpoolSearchRejected SUM is >=1{ math expression DIFF ( )} for 1 minute, 1 consecutive time
# Issue: These alarms notify you of domain issues that might impact performance and stability.
resource "aws_cloudwatch_metric_alarm" "threadpool_search_rejected_increase" {
  alarm_name          = "ThreadpoolSearchRejectedIncrease"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = "1"
  alarm_description   = "Increase in ThreadpoolSearchRejected SUM is >= 1"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]

  metric_query {
    id          = "e1"
    expression  = "DIFF(m1)"
    label       = "ThreadpoolSearchRejected Increase"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "ThreadpoolSearchRejected"
      namespace   = "AWS/ES"
      period      = "60"
      stat        = "Sum"

      dimensions = {
        DomainName = var.domain
        ClientId   = data.aws_caller_identity.current.account_id
      }
    }
  }
}
# Alarm: Increase in ThreadpoolWriteRejected SUM is >=1{ math expression DIFF ( )} for 1 minute, 1 consecutive time
# Issue: These alarms notify you of domain issues that might impact performance and stability.

resource "aws_cloudwatch_metric_alarm" "threadpool_write_rejected_increase" {
  alarm_name          = "ThreadpoolWriteRejectedIncrease"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = "1"
  alarm_description   = "Increase in ThreadpoolWriteRejected SUM is >= 1"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]

  metric_query {
    id          = "e1"
    expression  = "DIFF(m1)"
    label       = "ThreadpoolWriteRejected Increase"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "ThreadpoolWriteRejected"
      namespace   = "AWS/ES"
      period      = "60"
      stat        = "Sum"

      dimensions = {
        DomainName = var.domain
        ClientId   = data.aws_caller_identity.current.account_id
      }
    }
  }
}



###################################
# Other alarms you might consider
###################################



# Alarm: WarmFreeStorageSpace minimum is <= 10240 for 1 minute, 1 consecutive time
# Issue: An UltraWarm node in your cluster is down to 10 GiB of free storage space. See Lack of available storage space. This value is in MiB, so rather than 10240, we recommend setting it to 10% of the storage space for each UltraWarm node.
resource "aws_cloudwatch_metric_alarm" "warm_free_storage_space_alarm" {
  alarm_name          = "WarmFreeStorageSpace"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "WarmFreeStorageSpace"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "10240"
  alarm_description   = "An UltraWarm node in your cluster is down to 10 GiB of free storage space. This value is in MiB, so rather than 10240, we recommend setting it to 10% of the storage space for each UltraWarm node."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}
# Alarm: HotToWarmMigrationQueueSize is >= 20 for 1 minute, 3 consecutive times
# Issue: A high number of indexes are concurrently moving from hot to UltraWarm storage. Consider scaling your cluster.
resource "aws_cloudwatch_metric_alarm" "hot_to_warm_migration_queue_size_alarm" {
  alarm_name          = "HotToWarmMigrationQueueSize"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "HotToWarmMigrationQueueSize"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "20"
  alarm_description   = "A high number of indexes are concurrently moving from hot to UltraWarm storage. Consider scaling your cluster."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: HotToWarmMigrationSuccessLatency is >= 1 day, 1 consecutive time
# Issue: Configure this alarm so that you're notified if the HotToWarmMigrationSuccessCount x latency is greater than 24 hours if you’re trying to roll daily indexes.

resource "aws_cloudwatch_metric_alarm" "hot_to_warm_migration_success_latency_alarm" {
  alarm_name          = "OpenSearchHotToWarmMigrationSuccessLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = "86400" # 1 day in seconds
  alarm_description   = "The HotToWarmMigrationSuccessCount x latency is greater than 24 hours. Check if you're trying to roll daily indexes."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]

  metric_query {
    id          = "latency"
    expression  = "COUNT / 86400"
    label       = "HotToWarmMigrationSuccessLatency"
    return_data = "true"
  }

  metric_query {
    id = "COUNT"

    metric {
      metric_name = "HotToWarmMigrationSuccessCount"
      namespace   = "AWS/ES"
      period      = "86400"
      stat        = "Sum"

      dimensions = {
        DomainName = var.domain
        ClientId   = data.aws_caller_identity.current.account_id
      }
    }
  }
}



# Alarm: WarmJVMMemoryPressure maximum is >= 95% for 1 minute, 3 consecutive times
# Issue: The cluster could encounter out of memory errors if usage increases. Consider scaling vertically. OpenSearch Service uses half of an instance's RAM for the Java heap, up to a heap size of 32 GiB. You can scale instances vertically up to 64 GiB of RAM, at which point you can scale horizontally by adding instances.
resource "aws_cloudwatch_metric_alarm" "warm_jvm_memory_pressure_alarm" {
  alarm_name          = "OpenSearchWarmJVMMemoryPressure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "WarmJVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "95"
  alarm_description   = "The cluster could encounter out of memory errors if usage increases. Consider scaling vertically. OpenSearch Service uses half of an instance's RAM for the Java heap, up to a heap size of 32 GiB. You can scale instances vertically up to 64 GiB of RAM, at which point you can scale horizontally by adding instances."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}




# Alarm: WarmOldGenJVMMemoryPressure maximum is >= 80% for 1 minute, 3 consecutive times
# Issue: The cluster could encounter out of memory errors if usage increases. Consider scaling vertically. OpenSearch Service uses half of an instance's RAM for the Java heap, up to a heap size of 32 GiB. You can scale instances vertically up to 64 GiB of RAM, at which point you can scale horizontally by adding instances.
resource "aws_cloudwatch_metric_alarm" "warm_old_gen_jvm_memory_pressure_alarm" {
  alarm_name          = "WarmOldGenJVMMemoryPressure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "WarmOldGenJVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"
  alarm_description   = "The cluster could encounter out of memory errors if usage increases. Consider scaling vertically. OpenSearch Service uses half of an instance's RAM for the Java heap, up to a heap size of 32 GiB. You can scale instances vertically up to 64 GiB of RAM, at which point you can scale horizontally by adding instances."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: WarmToColdMigrationQueueSize is >= 20 for 1 minute, 3 consecutive times
# Issue: A high number of indexes are concurrently moving from UltraWarm to cold storage. Consider scaling your cluster.

resource "aws_cloudwatch_metric_alarm" "warm_to_cold_migration_queue_size_alarm" {
  alarm_name          = "WarmToColdMigrationQueueSize"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "WarmToColdMigrationQueueSize"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "20"
  alarm_description   = "A high number of indexes are concurrently moving from UltraWarm to cold storage. Consider scaling your cluster."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: HotToWarmMigrationFailureCount is >= 1 for 1 minute, 1 consecutive time
# Issue: Migrations might fail during snapshots, shard relocations, or force merges. Failures during snapshots or shard relocation are typically due to node failures or S3 connectivity issues. Lack of disk space is usually the underlying cause of force merge failures.

resource "aws_cloudwatch_metric_alarm" "hot_to_warm_migration_failure_count_alarm" {
  alarm_name          = "HotToWarmMigrationFailureCount"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HotToWarmMigrationFailureCount"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Migrations might fail during snapshots, shard relocations, or force merges. Failures during snapshots or shard relocation are typically due to node failures or S3 connectivity issues. Lack of disk space is usually the underlying cause of force merge failures."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: WarmToColdMigrationFailureCount is >= 1 for 1 minute, 1 consecutive time
# Issue: Migrations usually fail when attempts to migrate index metadata to cold storage fail. Failures can also happen when the warm index cluster state is being removed.

resource "aws_cloudwatch_metric_alarm" "warm_to_cold_migration_failure_count_alarm" {
  alarm_name          = "WarmToColdMigrationFailureCount"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "WarmToColdMigrationFailureCount"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Migrations usually fail when attempts to migrate index metadata to cold storage fail. Failures can also happen when the warm index cluster state is being removed."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: WarmToColdMigrationLatency is >= 1 day, 1 consecutive time
# Issue: Configure this alarm so that you're notified if the WarmToColdMigrationSuccessCount x latency is greater than 24 hours if you’re trying to roll daily indexes.

resource "aws_cloudwatch_metric_alarm" "warm_to_cold_migration_latency_alarm" {
  alarm_name          = "WarmToColdMigrationLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = "86400" # 1 day in seconds
  alarm_description   = "The WarmToColdMigrationSuccessCount x latency is greater than 24 hours. Check if you're trying to roll daily indexes."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  metric_query {
    id          = "latency"
    expression  = "COUNT / 86400"
    label       = "WarmToColdMigrationLatency"
    return_data = "true"
  }

  metric_query {
    id = "COUNT"

    metric {
      metric_name = "WarmToColdMigrationSuccessCount"
      namespace   = "AWS/ES"
      period      = "86400"
      stat        = "Sum"

      dimensions = {
        DomainName = var.domain
        ClientId   = data.aws_caller_identity.current.account_id
      }
    }
  }
}

# Alarm: AlertingDegraded is >= 1 for 1 minute, 1 consecutive time
# Issue: Either the alerting index is red, or one or more nodes is not on schedule.

resource "aws_cloudwatch_metric_alarm" "alerting_degraded_alarm" {
  alarm_name          = "AlertingDegraded"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "AlertingDegraded"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Either the alerting index is red, or one or more nodes is not on schedule."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: ADPluginUnhealthy is >= 1 for 1 minute, 1 consecutive time
# Issue: The anomaly detection plugin isn't functioning properly, either because of high failure rates or because one of the indexes being used is red.

resource "aws_cloudwatch_metric_alarm" "ad_plugin_unhealthy_alarm" {
  alarm_name          = "ADPluginUnhealthy"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ADPluginUnhealthy"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "The anomaly detection plugin isn't functioning properly, either because of high failure rates or because one of the indexes being used is red."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: AsynchronousSearchFailureRate is >= 1 for 1 minute, 1 consecutive time
# Issue: At least one asynchronous search failed in the last minute, which likely means the coordinator node failed. The lifecycle of an asynchronous search request is managed solely on the coordinator node, so if the coordinator goes down, the request fails.

resource "aws_cloudwatch_metric_alarm" "asynchronous_search_failure_rate_alarm" {
  alarm_name          = "AsynchronousSearchFailureRate"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "AsynchronousSearchFailureRate"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "At least one asynchronous search failed in the last minute, which likely means the coordinator node failed. The lifecycle of an asynchronous search request is managed solely on the coordinator node, so if the coordinator goes down, the request fails."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: AsynchronousSearchStoreHealth is >= 1 for 1 minute, 1 consecutive time
# Issue: The health of the asynchronous search response store in the persisted index is red. You might be storing large asynchronous responses, which can destabilize a cluster. Try to limit your asynchronous search responses to 10 MB or less.

resource "aws_cloudwatch_metric_alarm" "asynchronous_search_store_health_alarm" {
  alarm_name          = "AsynchronousSearchStoreHealth"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "AsynchronousSearchStoreHealth"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "The health of the asynchronous search response store in the persisted index is red. You might be storing large asynchronous responses, which can destabilize a cluster. Try to limit your asynchronous search responses to 10 MB or less."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: SQLUnhealthy is >= 1 for 1 minute, 3 consecutive times
# Issue: The SQL plugin is returning 5xx response codes or passing invalid query DSL to OpenSearch. Troubleshoot the requests that your clients are making to the plugin.

resource "aws_cloudwatch_metric_alarm" "sql_unhealthy_alarm" {
  alarm_name          = "SQLUnhealthy"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "SQLUnhealthy"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "The SQL plugin is returning 5xx response codes or passing invalid query DSL to OpenSearch. Troubleshoot the requests that your clients are making to the plugin."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# Alarm: LTRStatus.red is >= 1 for 1 minute, 1 consecutive time
# Issue: At least one of the indexes needed to run the Learning to Rank plugin has missing primary shards and isn't functional.

resource "aws_cloudwatch_metric_alarm" "ltr_status_red_alarm" {
  alarm_name          = "LTRStatus.red"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "LTRStatus.red"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "At least one of the indexes needed to run the Learning to Rank plugin has missing primary shards and isn't functional."
  alarm_actions       = [aws_sns_topic.alarms.arn]
  ok_actions          = [aws_sns_topic.alarms.arn]
  dimensions = {
    DomainName = var.domain
    ClientId   = data.aws_caller_identity.current.account_id
  }
}