module.exports = {
  purge: [
    "app/components/**/*.html.erb",
    "app/views/**/*.html.erb",
    "app/helpers/**/*.rb",
    "app/javascript/**/*.{js,jsx,ts,tsx}",
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      fontFamily: {
        inter: `'Inter', sans-serif`,
      },
      boxShadow: {
        max: "0 5px 60px -15px rgba(0, 0, 0, 0.1)",
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/forms"), require("@tailwindcss/typography")],
};
