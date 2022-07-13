## How to Setup a Recurring Security Hub Summary Email

This solution uses Security Hub custom insights, AWS Lambda, and the Security Hub API. A custom insight is a collection of findings that are aggregated by a grouping attribute, such as severity or status. Insights help you identify common security issues that may require remediation action. Security Hub includes several managed insights, or you can create your own custom insights.  

### Overview
A recurring Security Hub Summary email will provide recipients with a proactive communication summarizing the security posture and improvement within their AWS Accounts.  The email message contains the following sections:

- AWS Foundational Security Best Practices findings by status
- AWS Foundational Security Best Practices findings by severity
- Amazon GuardDuty findings by severity
- AWS IAM Access Analyzer findings by severity
- Unresolved findings by severity
- New findings in the last 7 days by security product 
- Top 10 resource types with the most findings

### Here’s how the solution works
1.	Seven Security Hub custom insights are created when the solution is first deployed.
2.	A CloudWatch time-based event invokes a Lambda function for processing.
3.	The Lambda function gets results of the custom insights from Security Hub, formats the results for email and sends a message to SNS.
4.	SNS sends the email notification to the address provided during deployment.
5.	The email includes the summary and links to the Security Hub UI to follow the remediation workflow.

![diagram](docs/diagram.png)