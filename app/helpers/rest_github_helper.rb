module RestGithubHelper
  
  def link_git_account(name)
    @linked_git_account = name
    Rails.logger.info "Linked Account #{name}"
  end
  
  def linked_git_account
     linked_git_account
  end
  
  def remove_linked_git_account
    @linked_git_account = nil
  end

end
