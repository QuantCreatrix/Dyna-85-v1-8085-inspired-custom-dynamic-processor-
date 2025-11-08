# Dyna-85 v1*
A dynamically parameterized 8-bit microprocessor inspired by 8085, implementing a unified control logic through field-based instruction decoding.
Unlike extensive number of similar opcodes in 8085 for same operation, this processor is featured by compressed instruction space by parameterizing opcodes. 

Motivation: Traditional 8-bit processors use redundant opcodes.
Problem: Increases instruction memory, control ROM complexity, and decoding logic.
Solution: A dynamic opcode system where subfields select operands — single control block, dynamic decoding.
Result: Simplified hardware, smaller control ROM, possibly faster decode stage.

Example: instead of having different opcodes like traditionally in 8085, for MOV A B; MOV C D and more combinations; here there's one unified opcode for MOV REG1 REG2 that can handle it as one. 

*v1 stands for since this project shared here features only one instruction MOV REG1 REG2. More instructions are being added. 
