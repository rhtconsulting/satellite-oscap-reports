import xml.etree.ElementTree as ET
from .openscap_finding import OpenSCAPFinding
import json
class ParseOpenSCAPXML(object):
    
    @staticmethod
    def get_findings(file_path):
        results = []
        
        namespaces = {
        'arf': 'http://scap.nist.gov/schema/asset-reporting-format/1.1',
        'xccdf': 'http://checklists.nist.gov/xccdf/1.2'
        } # add more as needed

        tree = None
        root = None
        try:          
            tree = ET.parse(file_path)
            root = tree.getroot()
        except:
            print("An exception occurred.  We can parse the file: " + file_path)
        
        if root == None:
            return results

        for group in root.findall(".//xccdf:Group", namespaces):
            
            title_elements = group.findall("./xccdf:title", namespaces)
            if len(title_elements) == 0:
                continue
            group_title = title_elements[0].text
            
            
            rule_elements = group.findall("./xccdf:Rule", namespaces)
            if len(rule_elements) == 0:
                continue
            rule_element = rule_elements[0]
           
            id = rule_element.attrib['id']
            severity = rule_element.attrib['severity']
            
            version_elements = rule_element.findall('./xccdf:version',namespaces)
            version = '***NO VERSION****'
            if len(version_elements) > 0:
                version = version_elements[0].text
                
            rule_title_elements = rule_element.findall('./xccdf:title',namespaces)
            rule_title = '***NO RULE TITLE****'
            if len(rule_title_elements) > 0:
                rule_title = rule_title_elements[0].text
           
            mitre_id_elements = rule_element.findall('./xccdf:ident[@system="http://cce.mitre.org"]',namespaces)
            mitre_id = '***NO MITRE ID****'
            if len(mitre_id_elements) > 0:
                mitre_id = mitre_id_elements[0].text
           
            
            disa_id_elements = rule_element.findall('./xccdf:ident[@system="http://iase.disa.mil/cci"]',namespaces)
            disa_id = '***NO DISA ID****'
            if len(disa_id_elements) > 0:
                disa_id = disa_id_elements[0].text
           
            
            finding = OpenSCAPFinding(id, disa_id, mitre_id, severity, False, group_title, rule_title, version)
            
            rule_results_elements = root.findall('.//xccdf:rule-result[@idref="{}"]'.format(id), namespaces)
            if not len(rule_results_elements) == 1 :
                continue
            rule_results_element = rule_results_elements[0]
            result_elements = rule_results_element.findall("./xccdf:result", namespaces)
            if len(result_elements) == 0:
                continue
            result = result_elements[0].text
            if result == 'pass':
                finding.is_passed = True
            
            results.append(finding)
        return results
            
