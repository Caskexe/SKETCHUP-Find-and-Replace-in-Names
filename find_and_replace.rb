#-------------------------------------------------------------------------------
#
# CASKexe
# Github CASKexe
# Find and Replace Names Plugin for SketchUp
# Description: Replaces specified text in component and group names, instance names, and definition names.
#
#-------------------------------------------------------------------------------

require 'sketchup.rb'
require 'extensions.rb'

#-------------------------------------------------------------------------------

module FindReplaceTool
  
	def self.find_and_replace(from_text, to_text)
		model = Sketchup.active_model
		definitions = model.definitions


		model.start_operation("Find and Replace Text in Names", true)

		definitions.each do |definition|
			# Skip image definitions
			next if definition.image?

			# Replace in definition name
			if definition.name.include?(from_text)
				definition.name = definition.name.gsub(from_text, to_text)
			end

			definition.instances.each do |instance|
				# Replace in instance name
				if instance.name.include?(from_text)
					instance.name = instance.name.gsub(from_text, to_text)
				end

				# Replace in group name
				if instance.is_a?(Sketchup::Group) && instance.name.include?(from_text)
					instance.name = instance.name.gsub(from_text, to_text)
				end
			end
		end

		model.commit_operation
	end

	def self.show_dialog
		prompts = ["Find Text (in definitions and instances):", "Replace With:"]
		defaults = ["text_to_replace", "new_text"]
		input = UI.inputbox(prompts, defaults, "Find and Replace Text in Names")

		return unless input
		from_text, to_text = input

		self.find_and_replace(from_text, to_text)
	end

	unless file_loaded?(__FILE__)
		menu = UI.menu("Plugins")
		menu.add_item("Find and Replace Text in Names") {
			self.show_dialog
		}
		file_loaded(__FILE__)
	end
end