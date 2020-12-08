import json
from json import JSONEncoder

class OpenSCAPFinding(object):
	
    is_passed = False
    id = ''
    disa_id = ''
    mitre_id = ''
    severity = ''
    version = ''
    group_title = ''

    def __init__(self, id, disa_id, mitre_id, severity, is_passed, group_title, rule_title, version):
        self.id = id
        self.disa_id = disa_id
        self.mitre_id = mitre_id
        self.severity = severity
        self.is_passed = is_passed
        self.group_title = group_title
        self.rule_title = rule_title
        self.version = version
        
    def get_dictionary_of_attributes(self):
        results = {'id': self.id, 'disa_id': self.disa_id, 
                  'mitre_id': self.mitre_id, 'severity': self.severity,
                  'is_passed': self.is_passed, 
                  'group_title': self.group_title  ,
                  'rule_title':  self.rule_title , 
                  'version': self.version
                }
        
        return results
        
    def __str__(self):
        results = ''
        results = results + '\n\t' + 'id:' + '\t\t' + self.id
        results = results + '\n\t' + 'disa_id:' + '\t\t' + self.disa_id
        results = results + '\n\t' + 'mitre_id:' + '\t\t' + self.mitre_id
        results = results + '\n\t' + 'severity:' + '\t\t' + self.severity
        results = results + '\n\t' + 'is_passed:' + '\t\t' + str(self.is_passed)
        results = results + '\n\t' + 'group_title:' + '\t\t' + self.group_title
        results = results + '\n\t' + 'rule_title:' + '\t\t' + self.rule_title
        results = results + '\n\t' + 'version:' + '\t\t' + self.version
        return results
    
# subclass JSONEncoder
class OpenSCAPFindingEncoder(JSONEncoder):
        def default(self, o):
            return o.__dict__
