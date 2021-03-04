module ApplicationHelper
  def cp(path, exact: false)
    exact ? request.fullpath == path : request.fullpath.start_with?(path)
  end

  def dom_ids(records)
    if records.is_a?(Array)
      records.map { |record| dom_id(record) }.join("_")
    else
      dom_id(records)
    end
  end
end
