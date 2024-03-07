## Azure tfstate Terraform module
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
Terraform module to create Remote State Storage resources for workload deployment on Azure Cloud.

## Usage Example

```hcl
module "backend" {
  source                    = "squareops/tfstate-asc/azurerm"
  resource_group_name       = "skaf"
  storage_account_name      = "storageaccount"
  storage_container_name    = "tfstate" # unique storage container name
  resource_group_location   = "eastus"
  environment               = "prod"
}
```
Refer [examples](https://github.com/squareops/terraform-azurerm-tfstate-asc/tree/main/examples/complete) for more details.

## Important Note
Terraform state locking is a mechanism used to prevent multiple users from simultaneously making changes to the same Terraform state, which could result in conflicts and data loss. A state lock is acquired and maintained by Terraform while it is making changes to the state, and other instances of Terraform are unable to make changes until the lock is released.

By using Azure Blob Storage as the backend for storing the tfstate file, Terraform automatically benefits from the built-in locking mechanism provided by Azure. This ensures the safety and consistency of your infrastructure state when working in a team or executing multiple Terraform operations simultaneously.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azure"></a> [azure](#requirement\_azure) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azure"></a> [azure](#provider\_azure) | >= 3.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |


## Outputs

| Name | Description |
|------|-------------|
| <a name="terraform_state_resource_group_name"></a> [terraform\_state\_resource\_group\_name](#output\_terraform\_state\_resource\_group\_name) | Name of the Resource Group that will be used to maintain resources list. |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_log\_bucket\_name) | Name of the Storage account where storage container will be created for storing tfstate. |
| <a name="output_storage_container_name"></a> [state\_storage\_container\_name](#output\_state\_storage\_container\_name) | Name of the Storage container where tfstate will be stored. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contribution & Issue Reporting

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/squareops/terraform-azurerm-tfstate-asc/issues) on GitHub
  2. Search to see if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Make sure to provide enough context and details .

## License

Apache License, Version 2.0, January 2004 (http://www.apache.org/licenses/).

## Support Us

To support a GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the [GitHub repository](https://github.com/squareops/terraform-azurerm-tfstate-asc)

  2. Click the "Star" button: On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Starring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 4 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

You can find more information about our company on this [squareops.com](https://squareops.com/), follow us on [Linkedin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =3.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend"></a> [backend](#module\_backend) | squareops/tfstate-asc/azurerm | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_terraform_state_resource_group_name"></a> [terraform\_state\_resource\_group\_name](#output\_terraform\_state\_resource\_group\_name) | The name of the resource group where Terraform state is stored |
| <a name="output_terraform_state_storage_account"></a> [terraform\_state\_storage\_account](#output\_terraform\_state\_storage\_account) | The name of the storage account where Terraform state is stored |
| <a name="output_terraform_state_storage_container_name"></a> [terraform\_state\_storage\_container\_name](#output\_terraform\_state\_storage\_container\_name) | The name of the storage container where Terraform state is stored |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
