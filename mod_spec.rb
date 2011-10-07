
class ModSpec

  def self.list
    [
      {:l => 0, :r => 5},
      {:l => 0, :r => 4},
      {:l => 0, :r => 3},
      {:l => 0, :r => 2},
      {:l => 0, :r => 1},
      {:l => 0, :r => 0},

      {:l => 1, :r => 5},
      {:l => 1, :r => 4},
      {:l => 1, :r => 3},
      {:l => 1, :r => 2},
      {:l => 1, :r => 1},

      {:l => 2, :r => 5},
      {:l => 2, :r => 4},
      {:l => 2, :r => 3},
      {:l => 2, :r => 2},

      {:l => 3, :r => 5},
      {:l => 3, :r => 4},
      {:l => 3, :r => 3},

      {:l => 4, :r => 5},
      {:l => 4, :r => 4},

      {:l => 5, :r => 5}
    ]
  end

  def self.get_command(byte)
    ModSpec.list[byte] || {:l => 0, :r => 5}
  end

  def self.get_byte(spec)
    ModSpec.list.index(spec) || 0
  end
end