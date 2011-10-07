class OpCodes
  def ld_(r)
    "ld#{r}"
  end

  def ld_n(r)
    "ld#{r}n"
  end

  def st_(r)
    "st#{r}"
  end

  def add
    "add"
  end

  def sub
    "sub"
  end

  def mul
    "mul"
  end

  def div
    "div"
  end
  
  def ent_(r)
    "ent#{r}"
  end

  def enn_(r)
    "enn#{r}"
  end

  def inc_(r)
    "inc#{r}"
  end

  def dec_(r)
    "dec#{r}"
  end

  def cmp_(r)
    "cmp#{r}"
  end

  def jmp
    "jmp"
  end

  def jsj
    "jsj"
  end

  def jov
    "jov"
  end

  def jnov
    "jnov"
  end
  
  def jl
    "jl"
  end

  def je
    "je"
  end

  def jg
    "jg"
  end

  def jge
    "jge"
  end

  def jne
    "jne"
  end

  def jle
    "jle"
  end

  def j_n(r)
    "j#{r}n"
  end

  def j_z(r)
    "j#{r}z"
  end

  def j_p(r)
    "j#{r}p"
  end
  
  def j_nn(r)
    "j#{r}nn"
  end

  def j_nz(r)
    "j#{r}nz"
  end

  def j_np(r)
    "j#{r}np"
  end

  def move
    "move"
  end

  def sla
    "sla"
  end

  def sra
    "sra"
  end

  def slax
    "slax"
  end

  def srax
    "srax"
  end  

  def slc
    "slc"
  end

  def src
    "src"
  end

  def nop
    "nop"
  end

  def hlt
    "hlt"
  end

  def in
    "in"
  end

  def out
    "out"
  end

  def ioc
    "ioc"
  end

  def jred
    "jred"
  end

  def jbus
    "jbus"
  end

  def num
    "num"
  end

  def char
    "char"
  end


end