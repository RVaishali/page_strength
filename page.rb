class Page

  def initialize
    @pages = {}
    @result = {}
  end

  def process_score(qkey,query)
    @result ||= {}
    page_res = {}
    @n ||= 8
    @pages.each do |key,page|
      sc = 0
      matching = page & query
      if matching.present?
        matching.each do |mat|
          sc += ((@n - page.index(mat)) * (@n - query.index(mat)))
        end
        page_res[key] = sc
      end
    end
    puts "#{qkey} <=> #{page_res.inspect}"
    @result[qkey] = page_res.sort_by{|k,v| [v*-1, k]}.map{|h| h[0]}[0..4]
  end

  def get_input
    File.open("input.txt", "r") do |f|
      f.each_line do |line| 
        l = line.split(' ')
        key_words = l[1..-1].map(&:downcase)
        if(l[0].upcase == "P")
          cnt = @pages.count
          key = "P"+(cnt+1).to_s
          @pages[key] = key_words
        else
          cnt = @result.count
          key = "Q" + (cnt+1).to_s
          process_score(key,key_words)
        end
      end
    end
  end

  def print_result
    @result.each do |key,res|
      puts "#{key} => #{res.join(' ')}"
    end
  end

end