from ansible.module_utils.basic import AnsibleModule
import xml.etree.ElementTree as ET
from ansible.module_utils.openscap_xml_parsing.openscap_finding import OpenSCAPFinding
from ansible.module_utils.openscap_xml_parsing.parse_openscap_xml import ParseOpenSCAPXML
        
ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': ['preview'],
    'supported_by': 'community'
}

DOCUMENTATION = '''
        ---
        module: custom_openscap_xml
        
        short_description: Gets a list of openscap objects and a summary given a Satellite OpenSCAP xml file.
        
        version_added: "2.8"
        
        description:
            - "The module translates the Satellite OpenSCAP XML to a list of JSON findings."
        
        author:
            - Bret Mullinix
        '''

EXAMPLES = '''
        # List all the findings and a summary of the findings for host1_openscap_report.xml
        
        - name: List all the mark down problems for host1_openscap_report.xml
          custom_openscap_xml:
            path: host1_openscap_report.xml

        '''

RETURN = '''
        findings_dictionary:
            description: Returns a dictionary containing the summary and the finding.
            type: dict
            returned: always
       '''

def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str', required=True)
    )


    # seed the result dict in the object
    # we primarily care about changed and state
    # change is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        findings_dictionary={}
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    file_path = module.params["path"]

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    total_findings = len(result)
    total_passed = 0
    total_failed = 0
    total_low_severity = 0
    total_medium_severity = 0
    total_high_severity = 0       
    findings = ParseOpenSCAPXML.get_findings(file_path)
    dict_of_findings = []
    for finding in findings:
        if finding.is_passed == 1:
            total_passed = total_passed + 1
        else:
            if finding.severity == 'medium':
                total_medium_severity = total_medium_severity + 1
            elif finding.severity == 'high':
                total_high_severity = total_high_severity + 1
            elif finding.severity == 'low':
                total_low_severity = total_low_severity + 1
            else:
                print('****SEVERITY = {}'.format(finding.severity))
            total_failed = total_failed + 1
        dict_of_finding = finding.get_dictionary_of_attributes()
        dict_of_findings.append(dict_of_finding)
    
    dictionary_of_results = { 'summary': { 'total_low_severity': total_low_severity,
    'total_medium_severity': total_medium_severity, 'total_high_severity': total_high_severity },
    'findings': dict_of_findings }
    result['findings_dictionary'] = dictionary_of_results

    # output
    no_failure = True
    if no_failure is False:
        failure_message = 'Failed.'
        module.fail_json(msg=failure_message, **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()