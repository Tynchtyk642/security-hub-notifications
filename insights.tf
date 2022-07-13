resource "aws_securityhub_insight" "compliance_status" {
  count = local.create_sns_notification
  name               = "Summary Email - 01 - AWS Foundational Security Best practices findings by compliance status"
  group_by_attribute = "ComplianceStatus"
  filters {
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
    type {
      comparison = "EQUALS"
      value      = "Software and Configuration Checks/Industry and Regulatory Standards/AWS-Foundational-Security-Best-Practices"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
  }
}

resource "aws_securityhub_insight" "sns_custom_insight2" {
  count = local.create_sns_notification
  name               = "Summary Email - 02 - Failed AWS Foundational Security Best practices findings by severity"
  group_by_attribute = "SeverityLabel"
  filters {
    compliance_status {
      comparison = "EQUALS"
      value      = "FAILED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
    type {
      comparison = "EQUALS"
      value      = "Software and Configuration Checks/Industry and Regulatory Standards/AWS-Foundational-Security-Best-Practices"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
  }
}

resource "aws_securityhub_insight" "sns_custom_insight3" {
  count = local.create_sns_notification
  name               = "Summary Email - 03 - Count of Amazon GuardDuty findings by severity"
  group_by_attribute = "SeverityLabel"
  filters {
    product_name {
      comparison = "EQUALS"
      value      = "GuardDuty"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
  }
}

resource "aws_securityhub_insight" "sns_custom_insight4" {
  count = local.create_sns_notification
  name               = "Summary Email - 04 - Count of IAM Access Analyzer findings by severity"
  group_by_attribute = "SeverityLabel"
  filters {
    product_name {
      comparison = "EQUALS"
      value      = "IAM Access Analyzer"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
  }
}

resource "aws_securityhub_insight" "sns_custom_insight5" {
  count = local.create_sns_notification
  name               = "Summary Email - 05 - Count of all unresolved findings by severity"
  group_by_attribute = "SeverityLabel"
  filters {
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "RESOLVED"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
  }
}

resource "aws_securityhub_insight" "sns_custom_insight6" {
  count = local.create_sns_notification
  name               = "Summary Email - 06 - new findings in the last 7 days"
  group_by_attribute = "ProductName"
  filters {
    created_at {
      date_range {
        unit  = "DAYS"
        value = 7
      }
    }

    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }

    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "RESOLVED"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
  }
}

resource "aws_securityhub_insight" "sns_custom_insight7" {
  count = local.create_sns_notification
  name               = "Summary Email - 07 - Top Resource Types with findings by count"
  group_by_attribute = "ResourceType"
  filters {
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
  }
}

