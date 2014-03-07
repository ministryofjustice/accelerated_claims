def diff_pdfs(file1, file2)
  # ignore the difference which shows that the documents are different
  # only because of the creation & modification timestamps
  result = %x(diff -ab #{file1} #{file2} -U 0).unpack("C*").pack("U*").scan(/[[:print:]]/).to_s
  result.gsub!(/^\W.+/, '')
  result.gsub!(/^(---|\+\+\+).*/, '')
  result.gsub!(/^@@.*/, '')
  result.gsub!(/.*\/(ModDate|CreationDate|ID).*/, '')
  result.gsub!(/^\n$/, '')
  result
end
