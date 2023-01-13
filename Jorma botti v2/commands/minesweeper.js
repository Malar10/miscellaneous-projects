const { SlashCommandBuilder } = require('@discordjs/builders');
const { MessageEmbed } = require('discord.js');

module.exports = {
	data: new SlashCommandBuilder()
		.setName('minesweeper')
		.setDescription('Its minesweeper, dumbo')
		.addIntegerOption(option =>
			option.setName('size')
				.setDescription('The size of the grid (max 15)')
				.setRequired(true))
		.addIntegerOption(option =>
			option.setName('mines')
				.setDescription('The amount of mines')
				.setRequired(true)),

	async execute(interaction) {
		
		const size = interaction.options.getInteger('size');
		const mines = interaction.options.getInteger('mines');

		if (size <= 15 && mines <= (size ** 2)) {

			const numbers = [":zero:", ":one:", ":two:", ":three:", ":four:", ":five:", ":six:", ":seven:", ":eight:"];

			const grid = [];
			for (let i = 0; i < size * size; i++) {
				grid.push(0);
			};

			const available = [];
			for (let i = 0; i < size * size; i++) {
				available.push(i);
			};

			//miinat
			for (let i = 0; i < mines; i++) {
				randomNum = Math.floor(Math.random() * (available.length - 1));

				grid.splice(available[randomNum], 1, "x");
				available.splice(randomNum, 1);
			};

			//print thingy
			var temp = "";
			const printable = [];

			for (let i = 0; i < size; i++) {
				for (let j = 0; j < size; j++) {
					if (grid[i * size + j] == "x") {
						temp += ":bomb:";
					} else {
						temp += numbers[grid[i * size + j]];
					};
				};
				printable.push(temp);
				temp = "";
			};

			const embed = new MessageEmbed()
				.setColor('#0099ff')
				.setTitle('Miinaharava')
				.setDescription(printable.join("\n"))

			await interaction.reply({ embeds: [embed] });

		} else {
			await interaction.reply("Size too big or too many mines, try again.");
		}
	},
};