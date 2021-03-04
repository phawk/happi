module ApplicationHelper
  def cp(path, exact: false)
    exact ? request.fullpath == path : request.fullpath.start_with?(path)
  end
end
