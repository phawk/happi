module Feature
  module_function

  def enabled?(feature_name, current_user = nil)
    case feature_name.to_sym
    when :admin_area
      current_user&.role?(:admin) || false
    else
      true
    end
  end
end
