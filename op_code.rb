class OpCode

  def self.list
    [
      'LDA', 'LDX', 'LD1', 'LD2', 'LD3', 'LD4', 'LD5', 'LD6',
      'LDAN', 'LDXN', 'LD1N', 'LD2N', 'LD3N', 'LD4N', 'LD5N', 'LD6N',
      'STA', 'STX', 'ST1', 'ST2', 'ST3', 'ST4', 'ST5', 'ST6', 'STJ', 'STZ',
      'ADD', 'SUB', 'MUL', 'DIV',
      'ENTA', 'ENTX', 'ENT1', 'ENT2', 'ENT3', 'ENT4', 'ENT5', 'ENT6',
      'ENNA', 'ENNX', 'ENN1', 'ENN2', 'ENN3', 'ENN4', 'ENN5', 'ENN6',
      'INCA', 'INCX', 'INC1', 'INC2', 'INC3', 'INC4', 'INC5', 'INC6',
      'DECA', 'DECX', 'DEC1', 'DEC2', 'DEC3', 'DEC4', 'DEC5', 'DEC6',
      'CMPA', 'CMPX', 'CMP1', 'CMP2', 'CMP3', 'CMP4', 'CMP5', 'CMP6',
      'JMP', 'JSJ', 'JOV', 'JNOV', 
      'JL', 'JE', 'JG', 'JLE', 'JNE', 'JGE',
      'JAN', 'JAZ', 'JAP', 'JANN', 'JANZ', 'JANP', 
      'JXN', 'JXZ', 'JXP', 'JXNN', 'JXNZ', 'JXNP', 
      'J1N', 'J1Z', 'J1P', 'J1NN', 'J1NZ', 'J1NP', 
      'J2N', 'J2Z', 'J2P', 'J2NN', 'J2NZ', 'J2NP', 
      'J3N', 'J3Z', 'J3P', 'J3NN', 'J3NZ', 'J3NP', 
      'J4N', 'J4Z', 'J4P', 'J4NN', 'J4NZ', 'J4NP', 
      'J5N', 'J5Z', 'J5P', 'J5NN', 'J5NZ', 'J5NP', 
      'J6N', 'J6Z', 'J6P', 'J6NN', 'J6NZ', 'J6NP', 
      'MOVE', 'SLA', 'SRA', 'SLAX', 'SRAX', 'SLC', 'SRC',
      'NOP', 'HLT', 'IN', 'OUT', 'IOC',
      'JRED', 'JBUS', 'NUM', 'CHAR'
    ]
  end

  def self.get_command(byte)
    OpCode.list[byte] || 'NOP'
  end

  def self.get_byte(command)
    OpCode.list.index(command.upcase) || 135
  end

  def self.get_command_type(command)
    return 'LD' if command.match /^LD\w$/
    return 'LDN' if command.match /^LD\wN$/
    return 'ST' if command.match /^ST\w$/

    return 'ADD' if command == 'ADD'
    return 'SUB' if command == 'SUB'
    return 'MUL' if command == 'MUL'
    return 'DIV' if command == 'DIV'

    return 'ENT' if command.match /^ENT\w$/
    return 'ENN' if command.match /^ENN\w$/
    return 'INC' if command.match /^INC\w$/
    return 'DEC' if command.match /^DEC\w$/
    return 'CMP' if command.match /^CMP\w$/

    return 'JMP' if command == 'JMP'
    return 'JSJ' if command == 'JSJ'
    return 'JOV' if command == 'JOV'
    return 'JNOV' if command == 'JNOV'

    return 'JL' if command == 'JL'
    return 'JE' if command == 'JE'
    return 'JG' if command == 'JG'
    return 'JLE' if command == 'JLE'
    return 'JNE' if command == 'JNE'
    return 'JGE' if command == 'JGE'

    return 'JN' if command.match /^J\wN$/
    return 'JZ' if command.match /^J\wZ$/
    return 'JP' if command.match /^J\wP$/
    return 'JNN' if command.match /^J\wNN$/
    return 'JNZ' if command.match /^J\wNZ$/
    return 'JNP' if command.match /^J\wNP$/

    return 'MOVE' if command == 'MOVE'
    return 'SLA' if command == 'SLA'
    return 'SRA' if command == 'SRA'
    return 'SLAX' if command == 'SLAX'
    return 'SRAX' if command == 'SRAX'
    return 'SLC' if command == 'SLC'
    return 'SRC' if command == 'SRC'
    return 'NOP' if command == 'NOP'
    return 'HLT' if command == 'HLT'
    return 'IN' if command == 'IN'
    return 'OUT' if command == 'OUT'
    return 'IOC' if command == 'IOC'
    return 'JRED' if command == 'JRED'
    return 'JBUS' if command == 'JBUS'
    return 'NUM' if command == 'NUM'
    return 'CHAR' if command == 'CHAR'
    
    raise "Unknown command type."
    
  rescue
    return 'NOP'
  end
end
