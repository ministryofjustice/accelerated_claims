def diff_pdfs(file1, file2)
  %x(diff -ab #{file1} #{file2} -U 0).unpack("C*").pack("U*").scan(/[[:print:]]/)
end
