module StyleHelper
  def button_classes
    class_variants("py-2 px-3 rounded-md cursor-pointer font-semibold inline-flex items-center justify-center",
      variants: {
        size: {
          sm: "py-1 px-2 text-sm",
          md: "",
          lg: "text-lg",
        },
        style: {
          default: "bg-gray-200 text-gray-500",
          primary: "bg-purple-600 text-white hover:bg-purple-500",
          danger: "bg-pink-500 text-white hover:bg-pink-400",
          outline: "bg-white text-gray-400 ring-2 ring-gray-300 ring-inset hover:ring-gray-400 hover:text-gray-500",
        },
        rounded: "rounded-full px-4",
        full: "w-full",
      },
      defaults: {
        size: :md,
        style: :default,
      }
    )
  end
end
