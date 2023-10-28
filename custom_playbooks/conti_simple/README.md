# Conti Simple Playbook

- Description: This playbook uses an existing C2 session to control a host inside of the subject environment. The playbook will instruct the host to perform several local host and domain-based reconnaissance tasks, simulate a kerberoasting attack by using an LDAP query to discover SPNs and then request tickets for the SPNs (the actual tickets retrieved are not exposed during playbook operation), and simulate lateral movement via a WMI call to another host within the subject environment. The WMI call does not execute a C2 implant on the target host. Instead, it uses the WMI call to generate a file using the fsutil utility that the playbook then uses to simulate a data staging and exfiltration operation. The playbook attempts to cleanup all artifacts (including terminating the C2 agent) prior to exiting.

- Setup:
  - Create the custom playbook type using the create_playbook_type command:

    `create_playbook_type --playbook_type=conti_simple --playbook_version=1.0.1 --playbook_template=<path_to_conti_simple.template_file>`

  - Upload the request_spn_tickets.ps1 file to the ./HAVOC workspace:

    `create_file --file_name=request_spn_tickets.ps1 --path=shared/ --local_path=<path_to_local_request_spn_tickets.ps1_file>`

  - Instruct your C2 task to download the request_spn_tickets.ps1 file from the shared workspace:

    `interact_with_task --task_name=<c2_task_name> --instruct_command=download_from_workspace --instruct_args={'file_name': 'request_spn_tickets.ps1'}`

  - Establish a C2 connection from a host inside of the subject environment.

- Execution:

  `run_playbook --playbook_name=<playbook_name> --playbook_type=conti_simple --playbook_timeout=0 --playbook_config={'variable': {'c2_task_name': '<c2_task_name>', 'lateral_movement_computer_name': '<lateral_movement_computer_name>', 'agent_name': '<agent_name>'}}`

- Variables:
  - c2_task_name - The name of the C2 task that the agent is connected to.
  - agent_name - The auto-generated name associated with the C2 agent that the playbook will be sending instructions to.
  - lateral_movement_computer_name - The host name or IP address of a system to be used for targeted reconnaissance and lateral movement operations.

- Notes:
  - The C2 agent inherits the permissions of the user that executes the launcher file. This user must be a domain user for the various domain reconnaissance operations to succeed and the user also requires local administrator privileges on the lateral movement computer for the lateral movement related operations to succeed.
