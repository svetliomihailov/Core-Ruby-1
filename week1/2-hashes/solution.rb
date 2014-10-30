class Array
  def exclude?(element)
    return false if self.include?(element)
    true
  end
end

class Hash
  def pick!(*keys)
    reject! { | k, _v | keys.exclude?(k) }
  end

  def pick(*keys)
    dup.pick!(*keys)
  end

  def except!(*keys)
    reject! { | k, _v | keys.include?(k) }
  end

  def except(*keys)
    dup.except!(*keys)
  end

  def compact_values!
    reject! { | _k, v | v .is_a?(FalseClass) || v.nil? }
  end

  def compact_values
    dup.compact_values!
  end

  def defaults!(hash)
    merge!(hash.merge(self))
  end

  def defaults(hash)
    dup.defaults!(hash)
  end
end
