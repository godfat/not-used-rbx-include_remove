
if defined?(:RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
  module IncludeRemove

    def include_remove mod
      raise TypeError.new('expected Module') unless mod.instance_of?(Module)
      raise ArgumentError.new('prohibited from removing Kernel') if mod == Kernel

      target, last = superclass_chain.inject(self){ |last, target|
        if target.kind_of?(IncludedModule) && target.module == mod
          break [target, last]
        else
          target
        end
      }

      if last
        last.superclass = target.superclass
        true
      else
        false
      end
    end

    def extend_remove mod
      metaclass.include_remove(mod)
    end

  end

  Module.include(IncludeRemove)

end
