class Module

  def include_remove mod
    raise TypeError.new('expected Module') unless mod.instance_of?(Module)
    raise ArgumentError.new('prohibited from removing Kernel') if mod == Kernel

    target, prev = superclass_chain.inject(self){ |prev, ancestor|
      if ancestor.kind_of?(IncludedModule) && ancestor.module == mod
        break [ancestor, prev]
      else
        ancestor
      end
    }

    if prev
      prev.superclass = target.superclass
      true
    else
      false
    end
  end

  def extend_remove mod
    metaclass.include_remove(mod)
  end

end
