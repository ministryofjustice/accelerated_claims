module ClaimantHelper
  

  def claimant_header claimant_id
    if claimant_id == 1
      "<h3>Claimant #{claimant_id}</h3>".html_safe
    else
      "<h3>Claimant #{claimant_id} <span class='hint hide js-claimanttype'>(optional)</span></h3>".html_safe
    end
  end
end