const { SlashCommandBuilder } = require('@discordjs/builders');

module.exports = {
	data: new SlashCommandBuilder()
		.setName('dice')
		.setDescription('Returns a random number')
		.addIntegerOption(option =>
			option.setName('max')
				.setDescription('Highest number you want')
				.setRequired(true)),

	async execute(interaction) {
		const max = interaction.options.getInteger('max');
		await interaction.reply(Math.floor(Math.random() * max).toString());
	},
};