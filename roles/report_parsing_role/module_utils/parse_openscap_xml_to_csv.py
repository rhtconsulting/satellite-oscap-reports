import unittest

from openscap_xml_parsing.parse_openscap_xml import ParseOpenSCAPXML
from openscap_xml_parsing.openscap_finding import OpenSCAPFinding
class TestParseOpenSCAP(unittest.TestCase):

    def test_parse_openscap(self):
        results = ParseOpenSCAPXML.get_findings('openscap_report.xml')
        total_findings = len(results)
        total_passed = 0
        total_failed = 0
        total_low_severity = 0
        total_medium_severity = 0
        total_high_severity = 0       
       
        for finding in results:
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
            print('The finding ------->\n' + str(finding))
        print ('The total findings are {}'.format(total_findings))
        print ('The total passed are {}'.format(total_passed))  
        print ('The total failed are {}'.format(total_failed)) 
        print ('The total low severity are {}'.format(total_low_severity))
        print ('The total medium severity are {}'.format(total_medium_severity))
        print ('The total high severity are {}'.format(total_high_severity))

       

if __name__ == '__main__':
    unittest.main()
