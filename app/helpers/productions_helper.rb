module ProductionsHelper
  def cs(as, bs)
    @merge = []
    as.zip(bs).each do |a, b|
      @merge.push(a)
      @merge.push(b)
    end
  end
  
  def judgment(as, bs)
    merge = []
    as.zip(bs).each do |a, b|
      merge.push(a)
      merge.push(b)
    end

    merge_length = merge.length / 2
    (0..merge_length).each do |i|
      if cs[i] >= cs[i + 1]
        puts "nooooooo"
        break
      end
    end
  end
end
