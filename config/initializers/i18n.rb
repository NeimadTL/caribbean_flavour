LANGUAGES = [
	['English', 'en'],
	['French', 'fr']
]

I18n.available_locales = LANGUAGES.map { |language| language[1] }

I18n.default_locale = :fr
