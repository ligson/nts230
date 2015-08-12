package nts.program.domain

import nts.program.domain.Program

class RelationProgram {
	static belongsTo = [program:Program,relationProgram:Program]
}
