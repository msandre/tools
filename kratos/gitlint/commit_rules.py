from gitlint.rules import LineRule, RuleViolation, CommitMessageTitle
import re

class KratosCommitTitle(LineRule):
    """ A rule for Kratos commit titles
    The rule is adapted from conventional commits:
    https://www.conventionalcommits.org/en/v1.0.0-beta.2/
    """

    name = "kratos-commit-title"
    id = "KC1"
    target = CommitMessageTitle

    def _has_valid_format(self, line):
        pattern = re.compile(r"[a-z]+(\([A-Za-z_]+\))?: [a-z]([ a-z0-9_]|(\.h |\.cpp |\.py ))*$")
        if not pattern.match(line) is None:
            return True
        else:
            return False

    def _get_type(self, line):
        pattern = re.compile(r"[a-z]+")
        m = pattern.match(line)
        if m:
            return line[:m.end()]
        else:
            return None

    def _get_scope(self, line):
        pattern = re.compile(r"\([A-Za-z_]+\):")
        m = pattern.search(line)
        if m:
            return line[m.start():m.end()].lstrip('(').rstrip('):')
        else:
            return None

    def validate(self, line, commit):
        match_found = False
        violations = []
        if not self._has_valid_format(line):
            violations.append(RuleViolation(self.id, "Commit title has an invalid format"))
        if not self._get_type(line) in ['build','ci','chore','docs','feat','fix','perf','refactor','revert','style','test']:
            violations.append(RuleViolation(self.id, "Commit title has an invalid type"))
        if not self._get_scope(line) in [None, 'core','applications','HDF5','FluidDynamics','StructuralMechanics','ContactStructuralMechanics','Pfem','PfemFluidDynamics','Mapping','MeshMoving','lang']:
            violations.append(RuleViolation(self.id, "Commit title has an invalid scope"))
        return violations
